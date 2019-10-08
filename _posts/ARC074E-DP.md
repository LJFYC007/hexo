---
title: '[ARC074E]DP'
date: 2019-10-08 08:41:05
tags:
  - DP
---

我们可以记 $dp_{i,r,g,b}$ 为当前考虑到 $i$ 点，红/黄/蓝最后一次出现的位置分别为 $r,g,b$ 的方案数

考虑限制放在 $r_i$ 上，对于每一个 $r_i$ 判断是否合法，可以通过颜色状态得到

即对于限制 $l_i,r_i,x_i$ 满足当且仅当 $i=r_i$ 时 $r,g,b$ 中有 $x_i$ 个大于等于 $l_i$

<!-- more -->

这个可以预处理把这些不满足条件的状态去掉

同时肯定有一种颜色放在 $i$ 点，所以可以省去一维

转移状态时直接转移即可，注意分类讨论

```c++
/***************************************************************
	File name: AtCoder074E.cpp
	Author: ljfcnyali
	Create time: 2019年10月08日 星期二 08时41分45秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
#define pii pair<int, int>
#define int long long
typedef long long LL;

const int maxn = 310;
const int Mod = 1e9 + 7;

int f[maxn][maxn][maxn], n, m, ans;
bool vis[maxn][maxn][maxn];

inline void Solve(int l, int r, int x)
{
    if ( x == 1 ) 
    {
        REP(i, l, r - 1) REP(j, 0, r - 1) vis[r][i][j] = vis[r][j][i] = true;
        return ;
    }
    if ( x == 2 )
    {
        REP(i, l, r - 1) REP(j, l, r - 1) vis[r][i][j] = true;
        REP(i, 0, l - 1) REP(j, 0, l - 1) vis[r][i][j] = true;
        return ;
    }
    REP(i, 0, l - 1) REP(j, 0, r) vis[r][j][i] = vis[r][i][j] = true;
}

signed main()
{
    scanf("%lld%lld", &n, &m);
    REP(i, 1, m)
    {
        int l, r, x; scanf("%lld%lld%lld", &l, &r, &x);
        Solve(l, r, x);
    }
    f[1][0][0] = 1;
    REP(i, 1, n - 1)
    {
        REP(j, 0, i - 1)
            REP(k, 0, max(0ll, j - 1))
            {
                if ( vis[i][j][k] || !f[i][j][k] ) continue ;
                f[i + 1][j][k] = (f[i + 1][j][k] + f[i][j][k]) % Mod;
                f[i + 1][i][k] = (f[i + 1][i][k] + f[i][j][k]) % Mod;
                f[i + 1][i][j] = (f[i + 1][i][j] + f[i][j][k]) % Mod;
            }
    }
    REP(i, 0, n - 1) REP(j, 0, max(0ll, i - 1)) if ( !vis[n][i][j] ) ans = (ans + f[n][i][j]) % Mod;
    printf("%lld\n", (ans * 3) % Mod);
    return 0;
}
```

