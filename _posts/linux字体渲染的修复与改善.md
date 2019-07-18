---
title: 'linux字体渲染的修复与改善'
date: 2019-07-18 19:32:26
tags:
  - linux
---

我的电脑系统为Ubuntu 18.04.2 LTS

本篇文章主要解决两个问题

<!-- more -->

* 对于luogu、loj​代码块，简书等部分博客代码块，部分linux软件如typora​的代码块等出现等宽字体不正常、未显示等宽字体的修复与改善

  ![](/images/1.jpg)

* linux​中文字体渲染的修复与改善

### 前置知识

首先我们常用字体主要有两类:中文字体和拉丁字体

而通常字体分为如下几类

* 衬线字体(Serif)，这种字体适合打印使用而不是液晶屏
* 无衬线字体(Sans Serif)，与Serif恰好相反
* 等宽字体(Monospace或Mono)，一般是程序员的最爱，一个中文等宽字体等于两个拉丁等宽字体

### 等宽字体修复

这个问题我发现有很多人有发生然后一直没有解决，我花费一天时间~~重装电脑~~进行修复最后终于发现一个~~可能~~可行的解决方案...~~如果不可以别喷~~QwQ

首先鸣谢@YaliKiWi 我一开始并没有发现问题的原因，但莫名其妙的发现有两个叫做fonts-noto-cjk和fonts-noto-cjk-extra的软件包，如果将其卸载问题即可解决，但会伴随中文字体的各种BUG

仔细研究后，问题原因其实是：这两个软件包是中文字体渲染包，但是编写者为了简洁直接将整个系统字体全部设为改字体(包括拉丁文字)，部分软件有自己的字体设置优先级较高就没有收到影响，其它的就因为没有安装该字体所以出锅了...

所以我们的问题成功转化为给系统英文等宽字体一个更高的优先级来覆盖掉这两个软件包的修改

我用开发者模式观察了一下各大OJ的代码块字体加载设置，主要有Monaco,Consolas,Ubuntu Mono三个等宽字体是一定会加载的，但Ubuntu安装Consolas只可以安装一个叫做YaHei Consolas Hybrid YaHei Consolas Hybird Regular的字体，所以考虑使用Ubuntu Mono和Monaco(推荐使用Monaco，我的Ubuntu Mono好像亲测失败)

首先安装[Monaco](http://d.xiazaiziti.com/en_fonts/fonts/m/Monaco.ttf)，在终端依次运行

`$sudo mkdir /usr/share/fonts/Monaco`

`$sudo cp Monaco.ttf /usr/share/fonts/Monaco`

`$cd /usr/share/fonts/Monaco`

`$sudo mkfontscale && sudo mkfontdir && sudo fc-cache -fv`

然后新建`~/.fonts.conf`，修改为(Ubuntu Mono和Monaco只需要一个即可，也可以都加上没问题)，这一步是添加这两个字体到系统的字体加载顺序中(这个文件是用户font配置文件)

```conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
<match>
	<test name="family"><string>sans-serif</string></test>
	<edit name="family" mode="prepend" binding="strong">
        <string>Monaco</string>
		<string>Ubuntu Mono</string>
	</edit>
</match>
<match>
	<test name="family"><string>serif</string></test>
	<edit name="family" mode="prepend" binding="strong">
        <string>Monaco</string>
		<string>Ubuntu Mono</string>
	</edit>
</match>
<match>
	<test name="family"><string>monospace</string></test>
	<edit name="family" mode="prepend" binding="strong">
        <string>Monaco</string>
		<string>Ubuntu Mono</string>
	</edit>
</match>
</fontconfig>
```

接下来还需要对系统的字体加载顺序进行修改，打开`$sudo vim /etc/fonts/conf.d/60-latin.conf`，在每一个`<prefer>`后面添加两行`<family>Monaco</family>`和`<family>Ubuntu Mono</family>`，给一个例子:

```conf
<alias>
	<family>serif</family>
	<prefer>
    	<family>Monaco</family>
```

这样就可以了

### 字体渲染修复

打开`/etc/fonts/conf.avail/64-language-selector-prefer.conf`，发现里面的代码JP(日语)优先度高于CS(中文)，所以将每一个CS代码移动到优先级最高的位置

另外linux中文字体很多hint打开但默认中文字体是没有hint的，所以最好新建文件`/etc/fonts/local.conf`，修改为

```conf
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
  <match target="font">
    <edit name="hintstyle" mode="assign">
      <const>hintnone</const>
    </edit>
  </match>
</fontconfig>
```

这样可以把所有字体的hint全部禁用

另外还有一些反锯齿、子像素渲染、字型微调、字型比例的骚操作，不过考虑到电脑系统差异很可能导致不可预料的问题，就不推荐了吧
