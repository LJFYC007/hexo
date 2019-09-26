---
title: '[CF710F]二进制分组+AC自动机'
date: 2019-09-26 18:49:59
tags:
  - CF
  - 二进制分组
  - AC自动机
---

### 题目大意

维护一个字符串集合，支持3种操作

*   插入一个字符串
*   删除一个字符串
*   给定一个模板串，求集合中的字符串出现次数

操作次数 $n\le 3\times10^5$ ，字符串总长度 $len\le3\times10^5$

<!-- more -->

### 思路

在2013年的国家集训队论文中提到了一种二进制分组的算法，即将每组询问按二进制分组，如:
$$
23=16+4+2+1\\24=16+8
$$
对于每一次插入字符串，就新建一个大小为1的分组，如果大小与上一个分组一样就依次暴力合并

因为这题需要求解字符串匹配次数，所以需要对于每一个分组构建一个AC自动机

合并分组的时候暴力重构所有的节点

删除操作和插入操作是独立的，所以可以再建一个二进制分组的AC自动机，答案减一下就可以

需要注意几个细节：

*   因为我是对于每一个分组都建一个AC自动机，所以需要动态分配内存防止MLE
*   在合并两个AC自动机的时候不能直接修改每个节点的 $next$ ，因为之前会构建 $Fail$ 失配指针导致修改 $next$ ，所以最好再建一个新的 $Next$ 数组保存原本的 $next$ 数组
*   答案可以全部存到一个点上，不要暴力跳来记录答案

### 代码

```c++
/***************************************************************
	File name: CF710F.cpp
	Author: ljfcnyali
	Create time: 2019年09月26日 星期四 14时42分48秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
typedef long long LL;

const int maxn = 300010;

int n;
char s[maxn];
struct AC
{
    struct node
    {
        int next[26], Next[26];
        LL val, num;
    } *Trie[20];
    int Next[20][maxn * 2], top, size[20], tot[20], Max;

    inline void INIT(int x, int y)
    {
        REP(i, 0, 25) Trie[x][y].Next[i] = 0;
        Trie[x][y].val = 0;
    }

    inline void Merge(int a, int b, int p, int q)
    {
        Trie[a][p].val += Trie[b][q].val;
        REP(i, 0, 25)
        {
            if ( !Trie[b][q].Next[i] ) continue ;
            if ( !Trie[a][p].Next[i] ) { Trie[a][p].Next[i] = ++ tot[a]; INIT(a, tot[a]); }
            Merge(a, b, Trie[a][p].Next[i], Trie[b][q].Next[i]);
        }
    }

    inline void Get(int a, int p)
    {
        REP(i, 0, 25) Trie[a][p].next[i] = Trie[a][p].Next[i];
        REP(i, 0, 25) if ( Trie[a][p].next[i] ) Get(a, Trie[a][p].next[i]);
    }

    inline void BFS(int x)
    {
        queue<int> Q; Q.push(1);
        while ( !Q.empty() ) 
        {
            int u = Q.front(); Q.pop();
            REP(i, 0, 25)
            {
                if ( !Trie[x][u].next[i] ) { Trie[x][u].next[i] = Trie[x][Next[x][u]].next[i]; continue ; }
                Q.push(Trie[x][u].next[i]);
                Next[x][Trie[x][u].next[i]] = Trie[x][Next[x][u]].next[i];
            }
            Trie[x][u].num = Trie[x][u].val + Trie[x][Next[x][u]].num;
        }
    }

    inline void Insert()
    {
        ++ top; Max = top;
        int x = 10000;
        if ( top <= 1 ) x = 300000;
        else if ( top <= 3 ) x = 100000;
        else if ( top <= 5 ) x = 50000;
        else if ( top <= 10 ) x = 20000;
        Trie[top] = (new node[x + 100]);
        size[top] = tot[top] = 1;
        REP(i, 0, 25) Trie[top][0].Next[i] = 1;
        int len = str(s + 1), p = 1; 
        REP(i, 1, len)
        {
            INIT(top, p);
            int c = s[i] - 'a';
            Trie[top][p].Next[c] = ++ tot[top];
            p = Trie[top][p].Next[c];
        }
        INIT(top, p);
        Trie[top][p].val = 1;
        while ( size[top] == size[top - 1] ) 
        {
            -- top;
            size[top] += size[top + 1];
            Merge(top, top + 1, 1, 1); 
        }
        REP(i, top + 1, Max) delete [] Trie[i];
        REP(i, 0, 25) Trie[top][0].next[i] = 1;
        Get(top, 1);
        BFS(top);
    }

    inline LL Solve(int x)
    {
        int len = str(s + 1), u = 1; LL ans = 0;
        REP(i, 1, len)
        {
            int c = s[i] - 'a';
            u = Trie[x][u].next[c];
            ans += Trie[x][u].num; 
        }
        return ans;
    }

    inline LL Query()
    {
        LL ans = 0;
        REP(i, 1, top) ans += Solve(i);
        return ans;
    }
} A, B;

signed main()
{
#ifndef ONLINE_JUDGE
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
#endif
    scanf("%d", &n);
    REP(i, 1, n)
    {
        int opt; scanf("%d %s", &opt, s + 1);
        if ( opt == 1 ) A.Insert();
        else if ( opt == 2 ) B.Insert();
        else { printf("%lld\n", A.Query() - B.Query()); fflush(stdout); }
    }
    return 0;
}
```

