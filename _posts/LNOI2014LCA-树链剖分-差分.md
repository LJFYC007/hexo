---
title: '[LNOI2014LCA]树链剖分+差分'
date: 2019-10-15 15:10:24
tags:
  - 树链剖分
  - 差分
---

### 题目大意

给定一棵树，每次给定 $l,r,x$ 询问 $\sum_{i=l}^rdep_{LCA(i,x)}$

<!-- more -->

### 思路

首先考虑如何转化 $dep_{LCA(i,x)}$ 可以将从 $i$ 点至根全部加1，询问时只需要求 $x$ 到根的点权和即可

但是该题有 $l,r$ 的限制条件，考虑差分

对于一个询问 $[l,r]$ 拆成 $[1,l-1]$ 和 $[1,r]$ 的两组询问，这样的两组询问是互不干扰的

可以将所有询问离线，按右端点排序，一次加入树上点，遇到询问的区间就记录一下答案

时间复杂度 $O(n\log_2^2n)$

### 代码

```c++
/***************************************************************
	File name: P4211.cpp
	Author: ljfcnyali
	Create time: 2019年10月15日 星期二 14时34分59秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
#define lson root << 1
#define rson root << 1 | 1
#define pii pair<int, int>
#define int long long
typedef long long LL;

const int maxn = 100010;
const int Mod = 201314;

struct node { int sum, lazy, len; } Tree[maxn << 2];
pair<int, pii> q[maxn];
int n, m, Begin[maxn], Next[maxn], To[maxn], e, dis[maxn], f[maxn];
int son[maxn], size[maxn], p[maxn], id[maxn], top[maxn], cnt, ans[maxn], N;

inline void add(int u, int v) { To[++ e] = v; Next[e] = Begin[u]; Begin[u] = e; }

inline void DFS1(int u, int fa)
{
    size[u] = 1; int Max = 0;
    for ( int i = Begin[u]; i; i = Next[i] ) 
    {
        int v = To[i]; if ( v == fa ) continue ;
        f[v] = u; dis[v] = dis[u] + 1;
        DFS1(v, u);
        size[u] += size[v];
        if ( size[v] > Max ) { Max = size[v]; son[u] = v; }
    }
}

inline void DFS2(int u, int t)
{
    id[u] = ++ cnt; p[cnt] = u; top[u] = t;
    if ( son[u] ) DFS2(son[u], t);
    for ( int i = Begin[u]; i; i = Next[i] ) 
    {
        int v = To[i]; if ( v == f[u] || v == son[u] ) continue ;
        DFS2(v, v);
    }
}

inline void Build(int root, int l, int r)
{
    Tree[root].len = r - l + 1;
    if ( l == r ) return ;
    int Mid = l + r >> 1;
    Build(lson, l, Mid); Build(rson, Mid + 1, r);
}

inline void PushUp(int root) { Tree[root].sum = Tree[lson].sum + Tree[rson].sum; }

inline void PushDown(int root) 
{
    if ( !Tree[root].lazy ) return ;
    int x = Tree[root].lazy; Tree[root].lazy = 0;
    Tree[lson].lazy += x; Tree[rson].lazy += x; 
    Tree[lson].sum += x * Tree[lson].len;
    Tree[rson].sum += x * Tree[rson].len;
}

inline void Modify(int root, int l, int r, int L, int R)
{
    if ( L <= l && r <= R ) 
    {
        Tree[root].sum += Tree[root].len; ++ Tree[root].lazy;
        return ;
    }
    PushDown(root);
    int Mid = l + r >> 1;
    if ( L <= Mid ) Modify(lson, l, Mid, L, R);
    if ( Mid < R ) Modify(rson, Mid + 1, r, L, R);
    PushUp(root);
}

inline int Query(int root, int l, int r, int L, int R)
{
    if ( L <= l && r <= R ) return Tree[root].sum;
    PushDown(root);
    int Mid = l + r >> 1, sum = 0;
    if ( L <= Mid ) sum += Query(lson, l, Mid, L, R);
    if ( Mid < R ) sum += Query(rson, Mid + 1, r, L, R);
    return sum;
}

inline void Update(int x)
{
    while ( x ) { Modify(1, 1, n, id[top[x]], id[x]); x = f[top[x]]; }
}

inline int Solve(int x)
{
    int sum = 0;
    while ( x ) { sum += Query(1, 1, n, id[top[x]], id[x]); x = f[top[x]]; }
    return sum % Mod;
}

signed main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    scanf("%lld%lld", &n, &m);
    REP(i, 2, n) { int x; scanf("%lld", &x); ++ x; add(x, i); } 
    dis[1] = 1; DFS1(1, 0); DFS2(1, 1); Build(1, 1, n);
    REP(i, 1, m) 
    { 
        int l, r, x; scanf("%lld%lld%lld", &l, &r, &x);
        ++ l; ++ r; ++ x;
        q[++ N].first = l - 1; q[N].second.first = x; q[N].second.second = -i;
        q[++ N].first = r; q[N].second.first = x; q[N].second.second = i;
    }
    sort(q + 1, q + N + 1);
    // REP(i, 1, N) printf("%lld %lld %lld\n", q[i].first, q[i].second.first, q[i].second.second);
    int now = 1;
    REP(i, 1, N)
    {
        while ( now <= q[i].first ) Update(now ++);
        int x = q[i].second.second;
        ans[abs(x)] += (x > 0 ? 1 : -1) * Solve(q[i].second.first);
    }
    REP(i, 1, m) printf("%lld\n", (ans[i] + Mod) % Mod);
    return 0;
}

```

