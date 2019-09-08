---
title: '[CF452F]线段树+Hash'
date: 2019-09-08 15:51:37
tags:
  - 线段树
  - Hash
---

这道题有一道一样的题[LuoguP2757](https://www.luogu.org/problem/P2757)，但那道题可以 $O(n^2)$ 水过去

<!-- more -->

首先提一个 $Hash$ 的技巧，假设有
$$
\begin{align}&Hash_1=p\times a_1\\&Hash_2=Hash_1+p^2\times a_2\\&\dots\end{align}
$$
假设我们要求 $a_x\dots a_y$ 的 $Hash$ 的值，可以用上面的 $Hash_i$ 的到

即值为 $Hash_y-Hash_x\times p^{y-x}$

再接着考虑这道题，首先保证了这个序列是 $1\rightarrow n$ 的排列，所以每一个数当且仅当出现一次

假设当前考虑到第 $i$ 个数字，值为 $a_i$ ，那么如果 $a_i$ 作为一个等差数列的中间值的话，应满足 $a_j<a_i$ 且 $a_j$ 已经在 $i$ 之前出现过， $2a_i-a_j$ 还未出现

可以使用一个 $bool$ 数组转化一下这个要求，设 $b_i$ 表示 $i$ 这个值是否出现过

那么如果 $a_i$ 不可能作出贡献当且仅当从以 $i$ 为中心的 $b$ 串是一个回文串，即任意 $x$ 都满足 $b_{a_i-x}=b_{a_i+x}$

那么就使用之前提到的 $Hash$ 来判断是否为回文串，因为要动态更新，用线段树或树状数组维护一下即可

```cpp
/***************************************************************
	File name: CF452F.cpp
	Author: ljfcnyali
	Create time: 2019年09月08日 星期日 15时14分49秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
#define lson root << 1
#define rson root << 1 | 1
#define int long long
typedef long long LL;

const int maxn = 300010;
const int Mod = 103;

int n, a[maxn], p[maxn];
struct node
{
    int val;
} Tree[maxn << 2][2];

inline int Query(int root, int l, int r, int L, int R, int k)
{
    if ( L <= l && r <= R ) return Tree[root][k].val;
    int Mid = l + r >> 1, sum = 0;
    if ( L <= Mid ) sum += Query(lson, l, Mid, L, R, k);
    if ( Mid < R ) sum += Query(rson, Mid + 1, r, L, R, k);
    return sum;
}

inline void PushUp(int root, int k)
{
    Tree[root][k].val = Tree[lson][k].val + Tree[rson][k].val;
}

inline void Modify(int root, int l, int r, int pos, int val, int k)
{
    if ( l == r ) { Tree[root][k].val = val; return ; }
    int Mid = l + r >> 1;
    if ( pos <= Mid ) Modify(lson, l, Mid, pos, val, k);
    else Modify(rson, Mid + 1, r, pos, val, k);
    PushUp(root, k);
}

signed main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    scanf("%lld", &n);
    REP(i, 1, n) scanf("%lld", &a[i]);
    p[0] = 1; REP(i, 1, n) p[i] = p[i - 1] * Mod;
    REP(i, 1, n)
    {
        int len = min(a[i] - 1, n - a[i]);
        int s1 = a[i] - len, s2 = n - a[i] - len + 1;
        int x = Query(1, 1, n, s1, a[i], 0);
        int y = Query(1, 1, n, s2, n - a[i] + 1, 1);
        if ( s1 > s2 ) y = y * p[s1 - s2];
        else x = x * p[s2 - s1];
        // printf("%lld %lld\n", x, y);
        if ( x != y ) { puts("YES"); return 0; }
        Modify(1, 1, n, a[i], p[a[i]], 0);
        // printf("%lld %lld %lld %lld\n", a[i], p[a[i]], n - a[i] + 2, p[n - a[i] + 1]);
        Modify(1, 1, n, n - a[i] + 1, p[n - a[i] + 1], 1);
    }
    puts("NO");
    return 0;
}
```

