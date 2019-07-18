---
title: USACO1.2.2-ride 
date: 2017-12-22 10:46:07
tags: 
  - 模拟
---

## 题目大意

给你两个字符串，每个字母表示一个数字，每个字符串的值为每个字母所代表的数字的乘积。如果这两个字符串的值$ mod\ 47$后相等，则输出"GO"，否则输出"STAY"。

<!--more-->

## Solution

很水对不对，直接暴力搞一遍字符串的值，判断一下就好了，USACO的题~~就是水~~，哈哈哈

## CPP

```C++
/*
ID: ljfcnya1
TASK: ride
LANG: C++
*/
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

char a[110], b[110];

int alen, blen, sum1, sum2;

int main()
{
    freopen("ride.in", "r", stdin);
    freopen("ride.out", "w", stdout);
    scanf("%s", a);
    getchar();
    scanf("%s", b);
    alen = str(a);
    blen = str(b);
    sum1 = 1;
    REP(i, 0, alen - 1)
        sum1 = sum1 * (a[i] - 'A' + 1);
    sum2 = 1;
    REP(i, 0, blen - 1)
        sum2 = sum2 * (b[i] - 'A' + 1);
    if ( sum1 % 47 == sum2 % 47 )
        printf("GO\n");
    else
        printf("STAY\n");
    return 0;
}

```

