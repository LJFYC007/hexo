---
title: '[POJ3417]LCA+树上差分'
date: 2019-06-02 09:46:10
tags:
  - LCA
  - 差分
---

### 题目大意

给定一棵树，树上的边称为主要边，另外在树上还添加了$m$条附加边

求当且仅当删除一条主要边一条附加边使树被分为两个联通块的方案数

### 分析

我们可以考虑当树上增加一条附加边$(u,v)$时会产生一个环

<!-- more -->

所以如果我们要删掉树上$u\rightarrow v$中的任意一条边当且仅当该附加边$(u,v)$也要删去

则令树上每一条边有一个值$sum[i]$

在添加附加边的时候转换为将树上$u\rightarrow v$上的每一条边$sum[i]+1$

接下来在考虑每一条边的时候

* 如果该边$sum[i]=0$则说明删去这条边和任意一条附加边就可以使树不连通

* 如果该边$sum[i]=1$则说明删去这条边和唯一一条附加边就可以使树不连通
* 否则无解

在处理$sum[i]$的时候可以使用树上差分的思想

令$f[i]$为差分数组

在添加附加边$(u,v)$的时候，根据树上差分的思想$f[u]+1,f[v]+1,f[LCA(u,v)]-2$

对于$sum[u]$我们重新定义为$u$和其父节点的连边的值

那么$sum[u]$也就是$u$以及$u$的子树的$f$数组和

另外对于根的$sum[root]$是不需要考虑的

```c++
/***************************************************************
	File name: POJ3417.cpp
	Author: ljfcnyali
	Create time: 2019年06月02日 星期日 09时28分29秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 

const int maxn = 1000010;

int Begin[maxn], To[maxn], Next[maxn], e, f[maxn];
int dis[maxn], n, m, ans, anc[maxn][30], sum[maxn];

inline void add(int u, int v)
{
	To[++ e] = v;
	Next[e] = Begin[u];
	Begin[u] = e;
}

inline void DFS(int u, int x)
{
	dis[u] = ++ x;
	for ( int i = Begin[u]; i; i = Next[i] ) 
	{
		int v = To[i]; if ( dis[v] ) continue ;
		anc[v][0] = u;
		DFS(v, x);
	}
}

inline int LCA(int x, int y)
{
	if ( dis[x] < dis[y] ) swap(x, y);
	for ( int j = 20; j >= 0; -- j )
		if ( dis[anc[x][j]] >= dis[y] )
			x = anc[x][j];
	if ( x == y ) return x;
	for ( int j = 20; j >= 0; -- j )
		if ( anc[x][j] != anc[y][j] )
		{
			x = anc[x][j]; y = anc[y][j];
		}
	return anc[x][0];
}

inline void DFS1(int u, int fa)
{
	sum[u] = f[u];
	for ( int i = Begin[u]; i; i = Next[i] ) 
	{
		int v = To[i]; 
		if ( v == fa ) continue ;
		DFS1(v, u);
		sum[u] += sum[v];
	}
}

int main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
	scanf("%d%d", &n, &m);
	REP(i, 1, n - 1) { int u, v; scanf("%d%d", &u, &v); add(u, v); add(v, u); }
	DFS(1, 0);
	REP(j, 1, 20) REP(i, 1, n) anc[i][j] = anc[anc[i][j - 1]][j - 1];
	REP(i, 1, m)
	{
		int u, v; scanf("%d%d", &u, &v);
		++ f[u]; ++ f[v]; f[LCA(u, v)] -= 2;
	}
	DFS1(1, 0);
	REP(i, 2, n) if ( sum[i] == 0 ) ans += m; else if ( sum[i] == 1 ) ans ++;
	printf("%d\n", ans);
    return 0;
}
```

