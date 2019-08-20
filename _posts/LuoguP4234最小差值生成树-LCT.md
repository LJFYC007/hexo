---
title: '[LuoguP4234最小差值生成树]LCT'
date: 2019-08-20 08:32:52
tags:
  - LCT
---

题目大意:给定一个图，求边权最大值与最小值的差值最小的生成树

<!-- more -->

这种题很显然跟LCT有关，首先将边权按照从小到大排序，固定边权最大值，为了保证答案更优，只需要维护边权最小值最大即可

LCT维护最小值$Min$和点权值最小的位置$MinPos$，考虑当前添加$u,v,w$的一条边

*   如果$u,v$不连通，直接$Link$

*   $Split(u,v)$找到$MinPos$并删去，连上$u,v$这条边，可以保证边权最小值最大

这道题细节在于如何保证当前是一棵最小生成树，可以拿一个$num$计数，如果遇见第一种情况就$++num$，当$num=n-1$的时候就是一棵生成树

因为每条边只会被加入和删除一次，记录最小生成树的最小值可以直接给每条边记录一个$vis$，判断答案的时候暴力跳即可

注意有自环需要特判

```c++
/***************************************************************
	File name: P4234.cpp
	Author: ljfcnyali
	Create time: 2019年08月18日 星期日 11时02分49秒
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
    int son[2], Min, id, fa, lazy;
} Tree[maxn];

int n, m, w[maxn], num, Min, ans = 0x3f3f3f3f;
bool vis[maxn];

struct Node
{
    int u, v, w;
    bool operator < (const Node &a) const { return w < a.w; } 
} a[maxn];

inline bool IsRoot(int x) { return (ls(fa(x)) == x || rs(fa(x)) == x) ? false : true; }

inline void PushUp(int x)
{
    Tree[x].Min = w[x]; Tree[x].id = x;
    if ( ls(x) && Tree[ls(x)].Min < Tree[x].Min ) { Tree[x].Min = Tree[ls(x)].Min; Tree[x].id = Tree[ls(x)].id; }
    if ( rs(x) && Tree[rs(x)].Min < Tree[x].Min ) { Tree[x].Min = Tree[rs(x)].Min; Tree[x].id = Tree[rs(x)].id; }
}

inline void Update(int x) { Tree[x].lazy ^= 1; swap(ls(x), rs(x)); }

inline void PushDown(int x)
{
    if ( !Tree[x].lazy ) return ;
    if ( ls(x) ) Update(ls(x));
    if ( rs(x) ) Update(rs(x));
    Tree[x].lazy = 0;
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

inline void Cut(int u, int v) { MakeRoot(u); if ( FindRoot(v) != u || fa(v) != u || ls(v) ) return ; fa(v) = rs(u) = 0; }

inline void Split(int u, int v) { MakeRoot(u); Access(v); Splay(v); }

inline bool Check(int u, int v) { MakeRoot(u); return FindRoot(v) == u; }

int main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    scanf("%d%d", &n, &m);
    REP(i, 1, m) scanf("%d%d%d", &a[i].u, &a[i].v, &a[i].w);
    sort(a + 1, a + m + 1);
    REP(i, 1, n) w[i] = 0x3f3f3f3f; REP(i, n + 1, n + m) w[i] = a[i - n].w;
    REP(i, 1, m)
    {
        if ( a[i].u == a[i].v ) continue ;
        if ( !Check(a[i].u, a[i].v) ) 
        {
            Link(a[i].u, i + n); 
            Link(i + n, a[i].v);
            ++ num; vis[i] = true;
        }
        else
        {
            Split(a[i].u, a[i].v);
            int x = Tree[a[i].v].id; Splay(x); fa(ls(x)) = fa(rs(x)) = 0;
            vis[x - n] = false;
            Link(a[i].u, i + n); Link(i + n, a[i].v);
            vis[i] = true;
        }
        if ( num == n - 1 ) 
        {
            while ( !vis[Min] ) ++ Min;
            ans = min(ans, a[i].w - a[Min].w); 
        }
    }
    printf("%d\n", ans);
    return 0;
}
```

