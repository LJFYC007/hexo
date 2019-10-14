---
title: '[JSOI2008Blue Mary开公司]李超树'
date: 2019-10-14 21:37:03
tags:
  - 李超树
---

今天刚学李超树，就来写一发题解

### 题目大意

给定一些直线，求 $x$ 点上 $f(x)$ 的最大值

<!-- more -->

### 李超树

李超树是用来维护一些直线的，通常来说，我们需要建立一棵线段树，线段树上的节点代表一个区间

对于每一个线段树上的节点，我们假设其区间为 $[L,R]$ 且中点为 $Mid$ ，则该节点上保存的直线为其子树保存的直线中 $f(Mid)$ 最大的一条直线

对于插入某一条直线，考虑递归

*   如果当前直线在 $Mid$ 处比原直线在 $Mid$ 处更优，则需要替换原直线
    *   若当前直线斜率较大，则将原直线递归至左子树，因为原直线只可能对左子树造成贡献
    *   若原直线斜率较大，则递归右子树
*   否则将当前直线递归
    *   若当前直线斜率较大，则递归右子树
    *   若原直线斜率较大，则递归左子树

这样每个节点上保存的直线都是在其子树中 $f(Mid)$ 最大的一个直线

询问只需要从根到某个单点取 $f(x)$ 的最大值

### 代码

```c++
/***************************************************************
	File name: P4254.cpp
	Author: ljfcnyali
	Create time: 2019年10月14日 星期一 21时16分45秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
#define pii pair<int, int>
#define lson root << 1
#define rson root << 1 | 1
#define int long long
typedef long long LL;

const int maxn = 200010;
const int N = 50000;

struct Line { double b, k; } ;
struct node { Line x; bool flag; } Tree[maxn << 2];

int n;
char s[20];

inline int f(Line x, int pos) { return x.k * pos + x.b; }

inline void Modify(int root, int l, int r, Line x)
{
    if ( !Tree[root].flag ) { Tree[root].flag = true; Tree[root].x = x; return ; }
    if ( l == r ) 
    {
        if ( f(Tree[root].x, l) < f(x, l) ) Tree[root].x = x;
        return ;
    }
    int Mid = l + r >> 1;
    if ( x.k > Tree[root].x.k ) 
        if ( f(x, Mid) > f(Tree[root].x, Mid) )
        {
            Modify(lson, l, Mid, Tree[root].x);
            Tree[root].x = x;
        }
        else Modify(rson, Mid + 1, r, x);
    if ( x.k <= Tree[root].x.k )
        if ( f(x, Mid) > f(Tree[root].x, Mid) )
        {
            Modify(rson, Mid + 1, r, Tree[root].x);
            Tree[root].x = x;
        }
        else Modify(lson, l, Mid, x);
}

inline int Query(int root, int l, int r, int pos)
{
    if ( !Tree[root].flag ) return 0;
    if ( l == r ) return f(Tree[root].x, pos);
    int Mid = l + r >> 1, ans = f(Tree[root].x, pos);
    if ( pos <= Mid ) ans = max(ans, Query(lson, l, Mid, pos));
    else ans = max(ans, Query(rson, Mid + 1, r, pos));
    return ans;
}

signed main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    scanf("%lld", &n);
    REP(i, 1, n)
    {
        scanf("%s", s + 1);
        if ( s[1] == 'P' ) 
        {
            Line x; scanf("%lf%lf", &x.b, &x.k);
            x.b -= x.k;
            Modify(1, 1, N, x);
            continue ;
        }
        int x; scanf("%lld", &x);
        printf("%lld\n", Query(1, 1, N, x) / 100);
    }
    return 0;
}
```

