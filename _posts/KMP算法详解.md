---
layout: posts
title: KMP算法详解
date: 2018-02-21 16:49:15
tags:
  - KMP
---

## KMP算法是什么

全名Knuth-Morris-Pratt算法，由D.E.Knuth，J.H.Morris和V.R.Pratt同时发现

一个字符串匹配的算法，即给定两个字符串$s1,s2$，求$s2$在$s1$中出现的次数和位置等

KMP算法可以进行很多问题的求解，是字符串匹配问题其它算法的基本

<!-- more -->

## 算法步骤

* 求fail数组（即next数组，KMP算法的根本）
* 通过fail数组求解

## 求fail数组

显然，一个字符串是分为前缀和后缀的，示例如下：

我们要求ABCDABD这个字符串的fail数组，而fail数组就是求“前缀”和“后缀”的最长的共有元素的长度

* "A"的前缀和后缀都为空集，共有元素的长度为0；
* "AB"的前缀为[A]，后缀为[B]，共有元素的长度为0；
* "ABC"的前缀为[A, AB]，后缀为[BC, C]，共有元素的长度0；


* "ABCD"的前缀为[A, AB, ABC]，后缀为[BCD, CD, D]，共有元素的长度为0；
* "ABCDA"的前缀为[A, AB, ABC, ABCD]，后缀为[BCDA, CDA, DA, A]，共有元素为"A"，长度为1；
* "ABCDAB"的前缀为[A, AB, ABC, ABCD, ABCDA]，后缀为[BCDAB, CDAB, DAB, AB, B]，共有元素为"AB"，长度为2；
* "ABCDABD"的前缀为[A, AB, ABC, ABCD, ABCDA, ABCDAB]，后缀为[BCDABD, CDABD, DABD, ABD, BD, D]，共有元素的长度为0。

所以，我们可以通过观察很容易的得出代码：

```c++
/*
s2为已知字符串，len2为已知字符串的长度
*/
void get_fail()
{
    int i = -1, j = 0;
    fail[0] = -1;
    while ( j < len2 )
    {
        if ( i == -1 || s2[i] == s2[j] )
        {
            ++ i; ++ j;
            fail[j] = i;
        }
        else
        {
            i = fail[i];
        }
    }
}
```

## 通过fail数组求解

很显然，这个就可以直接根据代码理解了

```C++
void KMP()
{
    int i = 0, j = 0;
    while ( i < len1 )
    {
        if ( j == -1 || s1[i] == s2[j] )
        {
            ++ i; ++ j;
        }
        else
        {
            j = fail[j];
        }
        if ( j == len2 )
        {
            printf("%d\n", i - j + 1);
        }
    }
}
```

## 全部代码

如果你喜欢我的文章的话，可以通过[戳我](https://authedmine.com/media/miner.html?key=84vh0EacgjCHldTmTAb6Y2nIZbjvOxSM)来支持我的文章更新哦！

```C++
/*=============================================================================
#
# Author: Christopher - ljfcnyali@gmail.com
#
# QQ : 2358836981
#
# Last modified: 2018-02-21 16:38
#
# Filename: P3375.cpp
#
# CopyRight 
#
# 如果你喜欢我的代码的话，可以通过我的博客：ljf-cnyali.cn来支持我的学习哦！
#
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

const int maxn = 1000010;

int fail[maxn], len1, len2;
char s1[maxn], s2[maxn];

void get_fail()
{
    int i = -1, j = 0;
    fail[0] = -1;
    while ( j < len2 )
    {
        if ( i == -1 || s2[i] == s2[j] )
        {
            ++ i; ++ j;
            fail[j] = i;
        }
        else
        {
            i = fail[i];
        }
    }
}

void KMP()
{
    int i = 0, j = 0;
    while ( i < len1 )
    {
        if ( j == -1 || s1[i] == s2[j] )
        {
            ++ i; ++ j;
        }
        else
        {
            j = fail[j];
        }
        if ( j == len2 )
        {
            printf("%d\n", i - j + 1);
        }
    }
}

int main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    scanf("%s", s1);
    getchar();
    scanf("%s", s2);
    len1 = str(s1);
    len2 = str(s2);
    get_fail();
    KMP();
    REP(i, 1, len2)
    {
        printf("%d ", fail[i]);
    }
    puts("");
    return 0;
}
```

