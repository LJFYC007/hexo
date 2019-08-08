---
title: '[APIO2014序列分割]斜率优化DP'
date: 2019-08-08 15:59:02
tags:
  - DP
  - 斜率优化
---

设$dp[i][j]$表示在第$i$个位置断开前面有$j$个块的最大总得分

<!-- more -->

方程可得$dp[i][j]=max(dp[k][j-1]+\sum_{x=k+1}^{i}a[x]\times \sum_{x=i+1}^{n}a[x])(0\leq k< i)$

观察式子，把第二维用滚动数组优化掉，$a[x]$用前缀和算一下

所以$dp[i]=max(dp[j]+(sum[i]-sum[j])\times(sum[n]-sum[i]))(0\leq j< i)$

假设$dp[i]$由$j$转移比由$k$转移更优，即:

$dp[j]+(sum[i]-sum[j])\times(sum[n]-sum[i])>dp[k]+(sum[i]-sum[k])\times(sum[n]-sum[i])$

化简一下:$dp[j]-sum[j]\times (sum[n]-sum[i])>dp[k]-sum[k]\times (sum[n]-sum[i])$

即:$\frac{dp[k]-dp[j]}{sum[k]-sum[j]}<sum[n]-sum[i]$

```c++
/***************************************************************
	File name: P3648.cpp
	Author: ljfcnyali
	Create time: 2019年08月08日 星期四 16时11分09秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
#define int long long 

const int maxn = 100010;

int dp[maxn][2], n, k, sum[maxn], Q[maxn], pre[maxn][210], o;

inline double slope(int i, int j) 
{ 
    if ( sum[j] == sum[i] ) return 0x3f3f3f3f;
    return (dp[j][o ^ 1] - dp[i][o ^ 1] - sum[j] * sum[j] + sum[i] * sum[i]) * 1.0 / (sum[i] - sum[j]); 
}

signed main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    scanf("%lld%lld", &n, &k);
    REP(i, 1, n) { int x; scanf("%lld", &x); sum[i] = sum[i - 1] + x; }
    REP(p, 1, k)
    {
        int head = 1, tail = 1;
        REP(i, 1, n)
        {
            while ( head < tail && slope(Q[head], Q[head + 1]) <= sum[i] ) ++ head;
            dp[i][o] = dp[Q[head]][o ^ 1] + (sum[i] - sum[Q[head]]) * sum[Q[head]];
            pre[i][p] = Q[head];
            while ( head < tail && slope(Q[tail - 1], Q[tail]) >= slope(Q[tail - 1], i) ) -- tail;
            Q[++ tail] = i;
        }
        o ^= 1;
    }
    printf("%lld\n", dp[n][o ^ 1]);
    int x = n;
    for ( int i = k; i >= 1; -- i ) { x = pre[x][i]; printf("%lld ", x); } puts("");
    return 0;
}
```

