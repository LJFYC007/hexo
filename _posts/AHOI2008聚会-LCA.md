---
title: '[AHOI2008聚会]LCA'
date: 2019-06-03 14:30:56
tags:
  - LCA
---

### 题目大意

给定一棵树，有三个点，求解一个点$u$令这三个点到$u$的距离最小

### 分析

首先我们已知对于任意两个点的最短距离肯定经过这两个点的$LCA$

<!-- more -->

那么对于三个点(假设这三个点为$x,y,z$，求解的答案为$u$)来说，有两种情况

* $x,y$在一个子树并且$x,y$的最近公共祖先$Anc$为这个子树的根，$z$与$Anc$不在一个子树上
　那么最后的答案肯定是$u=Anc$，因为此时保证了$x,y$距离最小，而如果$u!=Anc$答案肯定会比这个大

* $z$与$Anc$在一个子树上，但这种情况其实相当于$x,y,z$的顺序不同

所以算法可以很容易的得到:

* 首先求解$x,y$的$Anc$

* 计算$z$到$Anc$的距离统计答案

* 改变$x,y,z$的顺序重新计算

最后可能常数比较大因为这种方法最差有$6$个$log_2 n$，所以实际时间复杂度为$6nlog_2 n$

```c++
/***************************************************************
	File name: G.cpp
	Author: ljfcnyali
	Create time: 2019年06月03日 星期一 12时05分45秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( register int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 

const int maxn = 1100010;

int Begin[maxn], Next[maxn], To[maxn], e, p[20];
int dis[maxn], anc[maxn][20], n, m, ans, Anc, ans1;

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
		anc[v][0] = u; DFS(v, x);
	}
}

inline int get_len(int x, int y)
{
	int sum = 0;
	if ( dis[x] < dis[y] ) swap(x, y);
	for ( int j = 19; j >= 0; -- j ) if ( dis[anc[x][j]] >= dis[y] ) { x = anc[x][j]; sum += p[j]; }
	if ( x == y ) { Anc = x; return sum; }
	for ( int j = 19; j >= 0; -- j )
		if ( anc[x][j] != anc[y][j] )
		{
			x = anc[x][j]; y = anc[y][j];
			sum += p[j + 1];
		}
	Anc = anc[x][0];
	return sum + 2;
}

inline void read(int &x)
{
	x = 0;
	char c = getchar(); 
	while ( c < '0' || c > '9' ) c = getchar();
	while ( c >= '0' && c <= '9' ) { x = x * 10 + c - '0'; c = getchar(); }
}

inline void print(int x)
{
	if ( x > 9 ) print(x / 10);
	putchar(x % 10 + '0');
}

int main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
	read(n); read(m);
	int u, v, a, b, c, sum, k;
	REP(i, 1, n - 1) { read(u); read(v); add(u, v); add(v, u); }
	DFS(1, 0);
	REP(j, 1, 19) REP(i, 1, n) anc[i][j] = anc[anc[i][j - 1]][j - 1];
	p[0] = 1; REP(i, 1, 19) p[i] = p[i - 1] * 2;
	REP(i, 1, m)
	{
		ans = 2147483647;
		read(a); read(b); read(c);

		sum = get_len(a, b); k = Anc; sum += get_len(k, c); 
		if ( sum < ans ) { ans = sum; ans1 = k; }

		sum = get_len(a, c); 
		if ( sum >= ans ) goto p1;
		k = Anc; sum += get_len(k, b); 
		if ( sum < ans ) { ans = sum; ans1 = k; }
p1: ;
		sum = get_len(b, c); 
		if ( sum >= ans ) goto p2;
		k = Anc; sum += get_len(k, a); 
		if ( sum < ans ) { ans = sum; ans1 = k; }
p2:;
   		print(ans1); putchar(' '); print(ans); putchar('\n');
//		printf("%d %d\n", ans1, ans);
	}
    return 0;
}
```

