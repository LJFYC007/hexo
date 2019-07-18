---
title: '[NOI2019回家路线]DP'
date: 2019-07-16 19:38:32
tags:
  - DP
---

### 思路历程

* 首先看到题目立刻想到最短路，可以建边然后在正常的最短路上加一维$dis[i][j]$表示到达站点$i$时间为$j$的最小烦躁值，然后想了一下建边最差$m^2$，再加上一个最短路会跑得很慢一点都不稳定(我们机房有人写了~~85~~或~~95~~，一脸忧郁)
* 接下来发现DFS可能很优秀...(谁知道可以跑~~满分~~)，但是因为复杂度太玄学不敢乱搞

<!-- more -->

* 考虑DP，我们令$dp[i][j]$同样表示站点$i$时间为$j$的最小烦躁值，然后考虑枚举$i$从$[1,m]$，$j$从$[0,a[i].p)$，然后对于有方程$dp[a[i].y][a[i].q]=min(dp[a[i].x][j]+js(j,a[i].p))$其中$js$为题目中的方程
* 发现这个算法显然是有后效性的，因为可以从后面的站点移动到前面的站点，即$a[i].x>a[i].y$
* 可以思考以$a[i].q$从小到大排序，这样就不会有后效性的问题，因为前面的时间不会对后面的造成影响，时空复杂度均为$O(mt)$，这样就完美的获得70分的好成绩
* 考虑算法瓶颈在于空间复杂度过高，开$long long$会导致$800MB$的空间，我们需要优化空间复杂度
* 因为发现会有很多无效的空间损耗($dp$数组中有很多点是$INF$的)，则使用$vector$进行数组优化，我们开一个$10^5$的$vector$，对于每一个$vector$存两个值$pos$和$val$，$pos$表示原$dp[i][j]$中的$j$，而$val$表示原$dp[i][j]$的值，在枚举$j$从$[p,a[i].p)$的时候修改为枚举$dp[i].size()$，然后进行修改即可

### 代码

```c++
// luogu-judger-enable-o2
/***************************************************************
    File name: route.cpp
    Author: ljfcnyali
    Create time: 2019年07月16日 星期二 08时46分17秒
***************************************************************/
#include<bits/stdc++.h>

using namespace std;

#define REP(i, a, b) for ( register LL i = (a), _end_ = (b); i <= _end_; ++ i ) 
#define mem(a) memset ( (a), 0, sizeof ( a ) ) 
#define str(a) strlen ( a ) 
typedef long long LL;

const int maxn = 100010;
const LL INF = 10000000000000;

LL n, m, A, B, C, s, t, Max, ans;

struct node
{
    LL x, y, p, q;
    bool operator < (const node &a) const { return q < a.q; }
} a[maxn << 1];

struct Node
{
    LL pos, val;
} p1, p2;

vector<Node> dp[maxn];

inline LL js(LL x, LL y) { LL t = y - x; return t * t * A + t * B + C; }

int main()
{
#ifndef ONLINE_JUDGE
    freopen("route.in", "r", stdin);
    freopen("route.out", "w", stdout);
#endif
    scanf("%lld%lld%lld%lld%lld", &n, &m, &A, &B, &C);
    REP(i, 1, m) { scanf("%lld%lld%lld%lld", &a[i].x, &a[i].y, &a[i].p, &a[i].q); Max = max(Max, a[i].q); }
    sort(a + 1, a + m + 1);
    REP(i, 1, m) 
        if ( a[i].x == 1 ) 
        {
            bool flag = false;
            REP(j, 0, dp[a[i].y].size() - 1)
            {
                p1 = dp[a[i].y][j];
                if ( p1.pos == a[i].q ) 
                {
                    p1.val = min(p1.val, a[i].p * a[i].p * A + a[i].p * B + C);
                    dp[a[i].y][j] = p1;
                    flag = true;
                    break ;
                }
            }
            if ( flag == false ) 
            {
                p1.pos = a[i].q; p1.val = a[i].p * a[i].p *A + a[i].p * B + C;
                dp[a[i].y].push_back(p1);
            }
        }
    REP(i, 1, m)
    {
        if ( a[i].x == 1 ) continue ;
        bool flag = false;
        REP(j, 0, dp[a[i].y].size() - 1)
        {
            p1 = dp[a[i].y][j];
            if ( p1.pos == a[i].q ) 
            {
                REP(k, 0, dp[a[i].x].size() - 1)
                {
                    p2 = dp[a[i].x][k];
                    if ( p2.pos > a[i].p ) continue ;
                    p1.val = min(p1.val, p2.val + js(p2.pos, a[i].p));
                }
                dp[a[i].y][j] = p1;
                flag = true; break ;
            }
        }
        if ( flag == false ) 
        {
            p1.pos = a[i].q; p1.val = INF;
            REP(k, 0, dp[a[i].x].size() - 1) 
            {
                p2 = dp[a[i].x][k];
                if ( p2.pos > a[i].p ) continue ;
                p1.val = min(p1.val, p2.val + js(p2.pos, a[i].p));
            }
            dp[a[i].y].push_back(p1);
        }
        // dp[a[i].y][a[i].q] = min(dp[a[i].y][a[i].q], dp[a[i].x][j] + js(j, a[i].p));
    }
    ans = INF;
    REP(i, 0, dp[n].size() - 1) ans = min(ans, dp[n][i].val + dp[n][i].pos);
    printf("%lld\n", ans);
    return 0;
}
```

