---
title: '[NOI2011阿狸的打字机]AC自动机'
date: 2019-10-20 10:56:09
tags:
  - AC自动机
---

之前一直不会AC自动机构建Fail树如何处理，这次终于学会了

<!-- more -->

首先考虑这道题暴力做法

*   将所有字符串加入Trie树中，构建Fail指针
*   对于每一次询问暴力匹配

可以发现对于一个询问 $x,y$ 其实等价于询问字符串 $y$ 的所有点能否通过跳Fail指针到字符串 $x$ 的结尾

考虑将所有Fail指针取反建立一棵Fail树

这样询问就变为了字符串 $y$ 中的点是否在字符串 $x$ 的结尾的子树中

但是这样子依旧不方便统计答案，考虑离线，按照 $y$ 为关键字排序

每次访问一个节点时将其权值+1，离开时-1，这样这棵树上有权值的点均为字符串 $y$ 中的点

如果访问到 $y$ 的结尾，可以进行询问每一个 $x$ 查看 $x$ 结尾的子树权值和

可以用树状数组来维护，因为每一个子树在DFS序上是连续的

```c++
/***************************************************************
	File name: P2414.cpp
	Author: ljfcnyali
	Create time: 2019年10月20日 星期日 09时36分32秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
#define pii pair<int, int>
typedef long long LL;

const int maxn = 200010;

int n, m, tot, Fail[maxn], Begin[maxn], Next[maxn], To[maxn], e;
int dfn[maxn], cnt, ans[maxn], size[maxn], c[maxn], t[maxn], num;
vector<pii> q[maxn];
char s[maxn];
struct node 
{ 
    int next[26], Next[26], fa; bool finish;
} Trie[maxn];

inline int lowbit(int x) { return x & -x; }

inline void Modify(int pos, int val)
{
    for ( int i = pos; i <= tot; i += lowbit(i) ) c[i] += val;
}

inline int Query(int pos)
{
    int sum = 0;
    for ( int i = pos; i > 0; i -= lowbit(i) ) sum += c[i];
    return sum;
}

inline void add(int u, int v) { To[++ e] = v; Next[e] = Begin[u]; Begin[u] = e; }

inline void Build()
{
    REP(i, 0, 25) Trie[0].next[i] = 1;
    int p = ++ tot;
    REP(i, 1, n)
    {
        if ( s[i] >= 'a' && s[i] <= 'z' ) 
        {
            char c = s[i] - 'a';
            if ( !Trie[p].next[c] ) Trie[p].next[c] = ++ tot;
            Trie[p].Next[c] = Trie[p].next[c];
            Trie[Trie[p].next[c]].fa = p; p = Trie[p].next[c];
        }
        else if ( s[i] == 'B' ) p = Trie[p].fa;
        else { t[++ num] = p; Trie[p].finish = true; }
    }
    queue<int> Q; Q.push(1);
    while ( !Q.empty() ) 
    {
        int u = Q.front(); Q.pop();
        REP(i, 0, 25)
        {
            if ( !Trie[u].next[i] ) { Trie[u].next[i] = Trie[Fail[u]].next[i]; continue ; }
            Fail[Trie[u].next[i]] = Trie[Fail[u]].next[i];
            Q.push(Trie[u].next[i]);
        }
    }
    REP(i, 1, tot) add(Fail[i], i);
}

inline void DFS(int u, int fa)
{
    size[u] = 1; dfn[u] = ++ cnt;
    for ( int i = Begin[u]; i; i = Next[i] ) 
    {
        int v = To[i]; if ( v == fa ) continue ;
        DFS(v, u);
        size[u] += size[v];
    }
}

inline void Solve(int u, int fa)
{
    Modify(dfn[u], 1);
    if ( Trie[u].finish ) 
        for ( auto i : q[u] ) 
            ans[i.second] = Query(dfn[i.first] + size[i.first] - 1) - Query(dfn[i.first] - 1);
    REP(i, 0, 25) if ( Trie[u].Next[i] ) Solve(Trie[u].Next[i], u);
    Modify(dfn[u], -1);
}

int main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    scanf("%s", s + 1); n = str(s + 1); 
    Build(); DFS(1, 0);
    scanf("%d", &m);
    REP(i, 1, m) 
    {
        int x, y; scanf("%d%d", &x, &y);
        q[t[y]].push_back(make_pair(t[x], i));
    }
    Solve(1, 0);
    REP(i, 1, m) printf("%d\n", ans[i]);
    return 0;
}

```

