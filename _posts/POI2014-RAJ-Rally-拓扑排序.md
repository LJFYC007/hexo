---
title: '[POI2014 RAJ-Rally]拓扑排序'
date: 2019-10-10 18:42:51
tags:
  - 拓扑排序
---

### 题目大意

给定一个DAG，其中每条边长度均为1，请找到一个点，使得删掉这个点后该图的最长路径最短

### 思路

观察题意，发现这是一个DAG，显然需要进行拓扑排序

首先考虑对于每一个点求出以其为起点或终点的最长路径长度

<!-- more -->

设以 $x$ 点为终点的最长路为 $dist_u$ ，以 $x$ 点为起点的最长路为 $diss_x$

这里给出一种做法来求解以某个点为终点的最长路径长度：

*   找到一个出度为0的点 $u$ ，则以该点为终点的最长路径长度为 $dist_u$
*   将所有连向这个点的出度减1，更新这些点的 $dist_v=max(dist_v,dist_u+1)$
*   重复上面的过程

是不是很像拓扑排序？以其为起点的话只要建一个反图一样的跑就可以了

接下来考虑求解答案

有一种很巧妙的方法是把点划分为 $A,B$ 两个集合且 $B$ 没有向 $A$ 的连边，则所有可能的路径为

*   $A\rightarrow A$
*   $A\rightarrow B$
*   $B\rightarrow B$

对于 $B$ 没有向 $A$ 的连边的限制可以按照拓扑排序依次由 $B$ 向 $A$ 中加点来实现

对于集合内部的边其实就是所有的点 $i$ 以其为起点或终点的最长路，例如

*   $A$ 中有点 $x$　，则 $A$ 中可能对答案造成贡献的点是 $dist_x$
*   同理 $B$ 中有点 $y$ ，则 $B$ 中可能对答案造成贡献的点是 $diss_y$

而 $A\rightarrow B$ 中的最长路可以在每次转移点的时候进行更新

最后答案可以用 $multiset$ 来维护

### 代码

```c++
/***************************************************************
	File name: P3573.cpp
	Author: ljfcnyali
	Create time: 2019年10月10日 星期四 17时08分04秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
#define pii pair<int, int>
typedef long long LL;

const int maxn = 500010;
const int INF = 0x3f3f3f3f;

int n, m, ans = INF, dis[maxn][2], in[maxn], a[maxn], pos;
multiset<int> S;

struct node
{
	int Begin[maxn], Next[maxn], To[maxn], e;
	int out[maxn], dis[maxn];

	inline void add(int u, int v) { To[++ e] = v; Next[e] = Begin[u]; Begin[u] = e; ++ out[v]; }

	inline void Solve()
	{
		queue<int> Q;
		REP(i, 1, n) if ( !out[i] ) Q.push(i);
		while ( !Q.empty() ) 
		{
			int u = Q.front(); Q.pop();
			for ( int i = Begin[u]; i; i = Next[i] ) 
			{
				int v = To[i]; -- out[v];
				dis[v] = max(dis[v], dis[u] + 1);
				if ( !out[v] ) Q.push(v);
			}
		}
	}
} A, B;

inline void Toposort()
{
	queue<int> Q; REP(i, 1, n) if ( !in[i] ) Q.push(i);
	int tot = 0;
	while ( !Q.empty() ) 
	{
		int u = Q.front(); Q.pop(); a[++ tot] = u;
		for ( int i = B.Begin[u]; i; i = B.Next[i] )
		{
			int v = B.To[i]; -- in[v];
			if ( !in[v] ) Q.push(v);
		}
	}
}

inline void erase(int x)
{
	auto it = S.find(x);
	S.erase(it);
}

int main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
	scanf("%d%d", &n, &m);
	REP(i, 1, m)
	{
		int u, v; scanf("%d%d", &u, &v);
		++ in[v];
		A.add(v, u); B.add(u, v);
	}
	A.Solve(); B.Solve();
	REP(i, 1, n) dis[i][0] = A.dis[i], dis[i][1] = B.dis[i];
	Toposort();
	REP(i, 1, n) S.insert(dis[i][0]);
	REP(j, 1, n)
	{
		int x = a[j];
		erase(dis[x][0]); 
		for ( int i = A.Begin[x]; i; i = A.Next[i] ) 
		{
			int v = A.To[i];
			erase(dis[v][1] + dis[x][0] + 1);
		}
		auto it = S.end(); -- it;
		if ( *it < ans ) { ans = *it; pos = x; }
		S.insert(dis[x][1]);
		for ( int i = B.Begin[x]; i; i = B.Next[i] ) 
		{
			int v = B.To[i];
			S.insert(dis[x][1] + dis[v][0] + 1);
		}
	}
	printf("%d %d\n", pos, ans);
    return 0;
}
```

