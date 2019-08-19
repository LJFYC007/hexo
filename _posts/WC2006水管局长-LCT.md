---
title: '[WC2006水管局长]LCT'
date: 2019-08-19 14:42:00
tags:
  - LCT
---

题目要求询问从$u$到$v$的一条路径使得该路径上的最大值最小，同时会进行删边操作

<!-- more -->

考虑询问，这道题跟[NOIP2013货车运输](https://www.luogu.org/problem/P1967)特别像，显然答案是在这个图的最小生成树上的，答案就是最小生成树上$u$到$v$的路径最大值

考虑如何维护这个图的最小生成树，删边操作不好进行可以把询问反过来进行加边操作

LCT维护最大值和最大值的边的编号，对于一次加边$u,v,w$

*   如果$u,v$不连通，加上这条边
*   加上这条边会形成一个环，先$Split(u,v)$，如果$w>Tree[v].max$那么这条边一定不在最小生成树上，否则就把$Tree[v].max\_pos$删去，加上$u,v$这条边

```c++
/***************************************************************
	File name: P4172.cpp
	Author: ljfcnyali
	Create time: 2019年08月19日 星期一 14时09分28秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
#define ls(x) Tree[x].son[0]
#define rs(x) Tree[x].son[1]
#define fa(x) Tree[x].fa
typedef long long LL;

const int maxn = 5000010;

struct node
{
    int son[2], lazy, fa, Max, id;
} Tree[maxn];

struct Node
{
    int u, v, w, opt;
} a[maxn];

int n, m, q, w[maxn], id[maxn], ans[maxn], cnt;
map<int, bool> Map;

inline bool IsRoot(int x) { return (ls(fa(x)) == x || rs(fa(x)) == x) ? false : true; }

inline void Update(int x) { Tree[x].lazy ^= 1; swap(ls(x), rs(x)); }

inline void PushUp(int x)
{
    Tree[x].Max = w[x]; Tree[x].id = x;
    if ( ls(x) && Tree[ls(x)].Max > Tree[x].Max ) Tree[x].Max = Tree[ls(x)].Max, Tree[x].id = Tree[ls(x)].id;
    if ( rs(x) && Tree[rs(x)].Max > Tree[x].Max ) Tree[x].Max = Tree[rs(x)].Max, Tree[x].id = Tree[rs(x)].id;
}

inline void PushDown(int x)
{
    if ( !Tree[x].lazy ) return ;
    Tree[x].lazy ^= 1;
    if ( ls(x) ) Update(ls(x)); if ( rs(x) ) Update(rs(x));
}

inline void Rotate(int x)
{
    int y = fa(x), z = fa(y), k = rs(y) == x, w = Tree[x].son[!k];
    if ( !IsRoot(y) ) Tree[z].son[rs(z) == y] = x;
    fa(x) = z; fa(y) = x; if ( w ) fa(w) = y;
    Tree[x].son[!k] = y; Tree[y].son[k] = w;
    PushUp(y);
}

inline void Splay(int x)
{
    stack<int> Stack; int y = x, z; Stack.push(y);
    while ( !IsRoot(y) ) Stack.push(y = fa(y));
    while ( !Stack.empty() ) { PushDown(Stack.top()); Stack.pop(); }
    while ( !IsRoot(x) ) 
    {
        y = fa(x); z = fa(y);
        if ( !IsRoot(y) ) Rotate((ls(y) == x) ^ (ls(z) == y) ? x : y);
        Rotate(x);
    }
    PushUp(x);
}

inline void Access(int root) { for ( int x = 0; root; x = root, root = fa(root) ) { Splay(root); rs(root) = x; PushUp(root); } }

inline void MakeRoot(int x) { Access(x); Splay(x); Update(x); }

inline int FindRoot(int x) { Access(x); Splay(x); while ( ls(x) ) x = ls(x); Splay(x); return x; }

inline void Link(int u, int v) { MakeRoot(u); if ( FindRoot(v) != u ) fa(u) = v; }

inline void Split(int u, int v) { MakeRoot(u); Access(v); Splay(v); }

inline bool Check(int u, int v) { MakeRoot(u); return FindRoot(v) == u; }

int main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    scanf("%d%d%d", &n, &m, &q);
    REP(i, 1, m) 
    {
        scanf("%d%d%d", &a[i].u, &a[i].v, &a[i].w);
        if ( a[i].u > a[i].v ) swap(a[i].u, a[i].v);
        id[a[i].u * n + a[i].v] = i;
        w[i + n] = a[i].w;
    }
    REP(i, m + 1, m + q) 
    {
        scanf("%d%d%d", &a[i].opt, &a[i].u, &a[i].v);
        if ( a[i].u > a[i].v ) swap(a[i].u, a[i].v);
        if ( a[i].opt == 2 ) Map[a[i].u * n + a[i].v] = true;
    }
    REP(i, 1, m)
    {
        if ( Map[a[i].u * n + a[i].v] == true ) continue ;
        if ( !Check(a[i].u, a[i].v) ) 
        {
            Link(a[i].u, i + n); 
            Link(i + n, a[i].v);
        }
        else
        {
            Split(a[i].u, a[i].v);
            if ( Tree[a[i].v].Max <= a[i].w ) continue ;
            int x = Tree[a[i].v].id; Splay(x); fa(ls(x)) = fa(rs(x)) = 0;
            Link(a[i].u, i + n); Link(i + n, a[i].v);
        }
    }
    for ( int i = q + m; i >= m + 1; -- i )
    {
        if ( a[i].opt == 1 ) 
        {
            Split(a[i].u, a[i].v);
            ans[++ cnt] = Tree[a[i].v].Max;
            continue ;
        }
        if ( !Check(a[i].u, a[i].v) ) { Link(a[i].u, i + n); Link(i + n, a[i].v); continue ; }
        int x = id[a[i].u * n + a[i].v];
        Split(a[i].u, a[i].v); if ( Tree[a[i].v].Max <= a[x].w ) continue ;
        int y = Tree[a[i].v].id; Splay(y); fa(ls(y)) = fa(rs(y)) = 0;
        Link(a[i].u, n + x); Link(n + x, a[i].v);
    }
    for ( int i = cnt; i >= 1; -- i ) printf("%d\n", ans[i]);
    return 0;
}
```

