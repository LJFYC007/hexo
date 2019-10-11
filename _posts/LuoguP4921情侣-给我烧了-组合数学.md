---
title: '[LuoguP4921情侣?给我烧了!]组合数学'
date: 2019-10-12 07:45:19
tags:
  - 组合数学
---

因为计算坐在一块的情侣非常方便，我们可以先设 $f(n)$ 表示有 $n$ 对情侣错排的方案数

假设我们已经求出了 $f(1)\dots f(n-1)$ ，现在需要求解 $f(n)$ ，考虑几种情况

<!-- more -->

*   新增的这一排为两个男生，则我们需要从 $n$ 个人中抽出两个男生，方案数为 $n\times(n-1)$

    因为这两个男生的情侣可以做一块也可以不做一块，考虑错排问题的经典思想

    *   如果两人不坐一块，则相当于有 $n-1$ 个人的错排问题，方案数为 $f(n-1)$

    *   否则相当于有 $n-2$ 个人的错排问题，另外两人可以交换座位，则方案数为 $2\times f(n-2)$ 

*   新增的这一排为两个女生，跟上面类似

*   新增的这一排为一男一女，则我们需要从 $n$ 个人中抽出一个男生和一个不是该男生的女生，方案数为 $n\times (n-1)$

    接下来考虑这两个人的情侣的做法，跟上面类似，同时因为我们抽出的一男一女可以交换座位，方案数要 $\times 2$

则 $f(n)$ 递推式为 $f(n)=4\times n\times (n-1)\times [f(n-1)+2\times f(n-2)]$

总方案非常好思考，我们要从 $n$ 对中抽出 $k$ 个情侣，再抽出 $k$ 个座位，每一对可以交换座位，则方案为：
$$
C_n^k\times A_n^k\times 2^k\times f(n-k)
$$
可以直接预处理后计数即可

```c++
/***************************************************************
	File name: P4921.cpp
	Author: ljfcnyali
	Create time: 2019年10月12日 星期六 07时36分16秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
#define pii pair<int, int>
#define int long long
typedef long long LL;

const int maxn = 1010; 
const int Mod = 998244353;

int fac[maxn], inv[maxn], T, n, ans, f[maxn];

inline int power(int a, int b)
{
    int r = 1;
    while ( b ) { if ( b & 1 ) r = (r * a) % Mod; a = (a * a) % Mod; b >>= 1; }
    return r;
}

inline int C(int n, int m) { return (fac[n] * inv[m] % Mod) * inv[n - m] % Mod; }

inline int A(int n, int m) { return fac[n] * inv[n - m] % Mod; }

signed main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    fac[0] = 1; REP(i, 1, 1000) fac[i] = fac[i - 1] * i % Mod;
    REP(i, 0, 1000) inv[i] = power(fac[i], Mod - 2);
    f[0] = 1; f[1] = 0;
    REP(i, 2, 1000) f[i] = 4 * i * (i - 1) * (f[i - 1] + (2 * i - 2) * f[i - 2] % Mod) % Mod;
    scanf("%lld", &T);
    while ( T -- ) 
    {
        scanf("%lld", &n);
        REP(i, 0, n) printf("%lld\n", (power(2, i) * (C(n, i) * A(n, i)  % Mod) % Mod) * f[n - i] % Mod);
    }
    return 0;
}
```

