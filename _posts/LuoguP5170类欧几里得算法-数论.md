---
title: 'LuoguP5170类欧几里得算法]数论'
date: 2019-11-11 19:37:07
tags:
  - 数论
---

类欧几里得算法可以用递归的方法求解，可以化化式子：
$$
\begin{align}
\sum_{i=0}^n\lfloor\dfrac{ai+b}{c}\rfloor=&\sum_{i=0}^ni\lfloor\dfrac{a}{c}\rfloor+\lfloor\dfrac{b}{c}\rfloor+\lfloor\dfrac{ai\mod c+b\mod c}{c}\rfloor\\
=&\dfrac{n(n+1)}{2}\lfloor\dfrac{a}{c}\rfloor+(n+1)\lfloor\dfrac{b}{c}\rfloor+\sum_{i=0}^n\lfloor\dfrac{ai\mod c+b\mod c}{c}\rfloor
\end{align}
$$
可以令 $f_{a,b,c,n}$ 表示 $\sum_{i=0}^n\lfloor\dfrac{ai+b}{c}\rfloor$ ，则可以化为
$$
f_{a,b,c,n}=\dfrac{n(n+1)}{2}\lfloor\dfrac{a}{c}\rfloor+(n+1)\lfloor\dfrac{b}{c}\rfloor+f_{a\mod c,b\mod c,c,n}
$$
