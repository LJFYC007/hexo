---
title: '[CF1244F Chips]题解'
date: 2019-10-27 21:01:30
tags:
  - CF
---

### 题目大意

有 $n$ 个棋子排成环状，标号为 $1\dots n$

<!-- more -->

一开始每个棋子都是黑色或白色的。随后有 $k$ 次操作。操作时，棋子变换的规则如下：我们考虑一个棋子本身以及与其相邻的两个棋子（共3个），如果其中白子占多数，那么这个棋子就变成白子，否则这个棋子就变成黑子。

注意，对于每个棋子，在确定要变成什么颜色之后，并不会立即改变颜色，而是等到所有棋子确定变成什么颜色后，所有棋子才同时变换颜色。

### 思路

考虑对于任意一个串，所有连续的 $WW$ 和 $BB$ 均不会被改变，并且会对所有的 $WBWBW...$ 这种交替的造成影响

所以可以把所有的 $WBWBW...$ 这样的串取出来，其改变的情况只会与 $k$ ，其该块左边的颜色，该块右边的颜色有关，分类讨论即可

注意这是一个环，可以把整个串复制接在最后面

### 代码

```c++
/***************************************************************
	File name: F.cpp
	Author: ljfcnyali
	Create time: 2019年10月27日 星期日 18时59分30秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
#define pii pair<int, int>
typedef long long LL;

const int maxn = 400010;

int n, k, a[maxn], ans[maxn];
char s[maxn];

inline int Check()
{
    int i = 1;
    while ( a[i] != a[i + 1] && i < n ) ++ i;
    return i;
}

inline void Solve(int L, int R)
{
    int x = a[L - 1], y = a[R + 1];
    REP(i, L, R)
    {
        int t = min(i - L, R - i) + 1;
        if ( t > k ) { ans[i] = (k & 1) ? 3 - a[i] : a[i]; continue ; }
        if ( i - L == R - i ) 
        { 
            if ( x == y ) ans[i] = x;
            else ans[i] = a[i]; 
            continue ; 
        }
        if ( i - L < R - i ) ans[i] = x;
        else ans[i] = y;
    }
}

int main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    scanf("%d%d", &n, &k);
    scanf("%s", s + 1);
    REP(i, 1, n) if ( s[i] == 'B' ) a[i] = 1; else a[i] = 2;
    REP(i, 1, n) a[n + i] = a[i];
    int l = Check(), r = l + n - 1;
    if ( l == n && a[n] != a[n + 1] )
    {
        l = r = 0;
        if ( k & 1 ) REP(i, 1, n) ans[i] = 3 - a[i];
        else REP(i, 1, n) ans[i] = a[i];
    }
    // REP(i, l, r) printf("%d ", a[i]); puts("");
    REP(i, l, r)
    {
        if ( a[i] == a[i + 1] || a[i] == a[i - 1] ) continue ;
        int L = i, R = i;
        while ( a[R] != a[R + 1] && R < r ) ++ R;
        if ( a[R] == a[R + 1] ) -- R;
        Solve(L, R);
        i = R;
    }
    REP(i, l, r) if ( !ans[i] ) ans[i] = a[i];
    REP(i, 1, l - 1) ans[i] = ans[i + n];
    REP(i, 1, n) printf("%c", ans[i] == 1 ? 'B' : 'W');
    puts("");
    return 0;
}

```

