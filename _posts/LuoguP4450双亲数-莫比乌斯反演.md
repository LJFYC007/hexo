---
title: '[LuoguP4450双亲数]莫比乌斯反演'
date: 2019-09-08 16:16:28
tags:
  - 数论
  - 莫比乌斯反演
---

求解 $\sum_{i=1}^a\sum_{j=1}^b[gcd(i,j)=d]$

<!-- more -->

慢慢化式子：
$$
\begin{align}
&\sum_{i=1}^a\sum_{j=1}^b[gcd(i,j)=d]\\
=&\sum_{i=1}^{\lfloor\frac{a}{d}\rfloor}\sum_{j=1}^{\lfloor\frac{b}{d}\rfloor}\sum_{p|gcd(i,j)}\mu(p)\\
=&\sum_{p=1}^{min(a,b)}\mu(p)\lfloor\frac{a}{pd}\rfloor\lfloor\frac{b}{pd}\rfloor
\end{align}
$$
直接数论分块即可

```cpp
/***************************************************************
	File name: P4450.cpp
	Author: ljfcnyali
	Create time: 2019年09月08日 星期日 16时27分14秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
#define int long long
typedef long long LL;

const int maxn = 1000010;

int Max = 1000000, n, m, d, ans;
int prime[maxn], tot, miu[maxn];
bool vis[maxn];

signed main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    scanf("%lld%lld%lld", &n, &m, &d);
    miu[1] = 1; 
    REP(i, 2, Max)
    {
        if ( !vis[i] ) { prime[++ tot] = i; miu[i] = -1; }
        for ( int j = 1; j <= tot && i * prime[j] <= Max; ++ j )
        {
            vis[i * prime[j]] = true;
            if ( i % prime[j] == 0 ) { miu[i * prime[j]] = 0; break ; }
            miu[i * prime[j]] = -miu[i];
        }
    }
    REP(i, 1, Max) miu[i] += miu[i - 1];
    n /= d; m /= d;
    int i = 1;
    while ( i <= min(n, m) ) 
    {
        int j = min(n / (n / i), m / (m / i));
        ans += (miu[j] - miu[i - 1]) * (n / i) * (m / i);
        i = j + 1;
    }
    printf("%lld\n", ans);
    return 0;
}
```

