---
layout: posts
title: LuoguP1722题解
date: 2018-02-22 12:44:15
tags:
  - DP
---

## 题目大意

给定一个$1*2n$的矩阵，现让你自由地放入红色算筹和黑色算筹，使矩阵平衡(即对于所有的$i(1<=i<=2n)$，使第$1\rightarrow i$格中红色算筹个数大于等于黑色算筹)

<!-- more -->

## 题目分析

这道题就是一道DP的题目，方法如下：

我们可以设$f[i][j]$表示$1\rightarrow i$中红色算筹比黑色算筹多$j$时的方案数

很明显我们可以得出一个DP方程，即考虑当前位置选红色算筹还是选择黑色算筹

$$f[i+1][j+1]=(f[i+1][j+1]+f[i][j])\%100$$
$$f[i+1][j-1]=(f[i+1][j-1]+f[i][j])\%100$$

即分别选择红色算筹和黑色算筹时的结果

另外注意初始条件$f[1][1]=1$和题目要求取模即可

答案即为$f[2*n][0]$

## AC代码

代码如下：如果你喜欢我的文章的话，可以通过[戳我](https://authedmine.com/media/miner.html?key=84vh0EacgjCHldTmTAb6Y2nIZbjvOxSM)来支持我的文章更新哦！

```c++
/*=============================================================================
#
# Author: Christopher - ljfcnyali@gmail.com
#
# QQ : 2358836981
#
# Last modified: 2018-02-21 19:58
#
# Filename: P1722.cpp
#
# CopyRight 
#
#
# 如果你喜欢我的代码的话，可以通过我的博客：ljf-cnyali.cn来支持我的学习哦！
=============================================================================*/

#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof (a) ) 
#define str(a) strlen ( a ) 
#define all(a) a.begin(), a.end()
typedef long long LL;
template<class T> int mmax(T a, T b) { return a > b ? a : b; }
template<class T> int mmin(T a, T b) { return a < b ? a : b; }
template<class T> int aabs(T a) { return a < 0 ? -a : a; }
#define max mmax
#define min mmin
#define abs aabs

int f[210][210];

int main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    int n;
    scanf("%d", &n); // 读入
    f[1][1] = 1; // 初始化
    REP(i, 0, n * 2)
    {
        REP(j, 0, n * 2)
        {   // 枚举i,j
            f[i + 1][j + 1] += f[i][j];
            f[i + 1][j + 1] %= 100; // 取红色算筹
            if ( j == 0 ) continue ; // 可能会出现-1
            f[i + 1][j - 1] += f[i][j];
            f[i + 1][j - 1] %= 100; // 取黑色算筹
        }
    }
    printf("%d\n", f[n * 2][0]); // 输出答案
    return 0;
}

```
