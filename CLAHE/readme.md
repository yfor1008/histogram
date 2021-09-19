# CLAHE

CLAHE 是一种非常有效的直方图均衡算法, 目前网上已经有很多文章进行了说明, 这里说一下自己的理解.

## CLAHE是怎么来的

直方图均衡是一种简单快速的图像增强方法, 其原理和实现过程以及改进可以查看这里: [一文搞懂直方图均衡_yfor1008-CSDN博客](https://blog.csdn.net/j05073094/article/details/120251878)

目前存在一些问题:

1. 直方图均衡是全局的, 对图像局部区域存在过亮或者过暗时, 效果不是很好;
2. 直方图均衡会增强背景噪声, 如下图所示为 CLAHE 中的示例:

![](readme.assets/human-knee.png)

为了解决上述2个问题, 就有2方面的解决方法: 一是解决全局性问题, 二是解决背景噪声增强问题.

- 针对全局性问题: 有人提出了对图像分块的方法, 每块区域单独进行直方图均衡, 这样就可以利用局部信息来增强图像, 这样就可以解决全局性问题;
- 针对背景噪声增强问题: 主要背景增强太过了, 因而有人提出了对对比度进行限制的方法, 这样就可以解决背景噪声增强问题;

将上述二者相结合就是 CLAHE 方法, 其全程为: Contrast Limited Adaptive Histogram Equalization.

## CLAHE 算法流程

CLAHE 算法流程主要有一下几个步骤:

1. 预处理, 如图像分块填充等;
2. 对每个分块处理, 计算映射关系, 计算映射关系时使用了对比度限制;
3. 使用插值方法得到最后的增强图像;

其处理流程可以用如下示意图表示:

![](readme.assets/stepsCLAHE.png)

## 关于关键步骤的说明

### 关于双线性插值

1. 对于每个分块都是将其分成 4 个子块, 然后每个子块于其相邻块的子块重新构成一个分块;
2. 对于新构成的块使用双线性插值得到增强后的图像;
3. 对于第1行的上面一行子块仅需考虑相邻行的上面一行子块, 最后行, 第1列及最后列同理;
4. 对于4个角上的子块, 直接使用本身所在块的映射关系, 不需要进行插值;

如下图所示:

![](readme.assets/clahe_interpolation.png)

### 关于限制对比度

CLAHE 中使用的方法是不断的循环, 直到将所有截断后多余的像素都添加到直方图中. 这种方法实现过程比较复杂, 个人认为可以简化, 如:

1. 截断后直接丢弃;
2. 截断后直接均匀添加到直方图所有的bin上;

上述2种方法应该对对比度影响不大, 但对图像亮度有一点点影响.

### 关于预处理

需对图像进行填充, 为方便进行插值, 填充后图像的每个分块都必须为2的整数倍, 要不然不方便对每个块划分为4个子块.

## 实现及效果





## 参考

1. [Contrast Limited Adaptive Histogram Equalization (CLAHE) - File Exchange - MATLAB Central (mathworks.com)](https://www.mathworks.com/matlabcentral/fileexchange/22182-contrast-limited-adaptive-histogram-equalization-clahe)
2. [Image Enhancement - CLAHE - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/150381937)
3. [CLAHE (Contrast Limited Adaptive Histogram Equalization) (amroamroamro.github.io)](http://amroamroamro.github.io/mexopencv/opencv/clahe_demo_gui.html)
4. [wangyanckxx/Single-Underwater-Image-Enhancement-and-Color-Restoration: Single Underwater Image Enhancement and Color Restoration, which is Python implementation for a comprehensive review paper "An Experimental-based Review of Image Enhancement and Image Restoration Methods for Underwater Imaging" (github.com)](https://github.com/wangyanckxx/Single-Underwater-Image-Enhancement-and-Color-Restoration)

