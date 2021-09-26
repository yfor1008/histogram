# CLAHE

CLAHE 是一种非常有效的直方图均衡算法, 目前网上已经有很多文章进行了说明, 这里说一下自己的理解.

## CLAHE是怎么来的

直方图均衡是一种简单快速的图像增强方法, 其原理和实现过程以及改进可以查看这里: [一文搞懂直方图均衡_yfor1008-CSDN博客](https://blog.csdn.net/j05073094/article/details/120251878)

目前存在一些问题:

1. 直方图均衡是全局的, 对图像局部区域存在过亮或者过暗时, 效果不是很好;
2. 直方图均衡会增强背景噪声, 如下图所示为 CLAHE 中的示例:

![](https://gitee.com/yfor1008/pictures/raw/master/human-knee.png)

为了解决上述2个问题, 就有2方面的解决方法: 一是解决全局性问题, 二是解决背景噪声增强问题.

- 针对全局性问题: 有人提出了对图像分块的方法, 每块区域单独进行直方图均衡, 这样就可以利用局部信息来增强图像, 这样就可以解决全局性问题;
- 针对背景噪声增强问题: 主要背景增强太过了, 因而有人提出了对对比度进行限制的方法, 这样就可以解决背景噪声增强问题;

将上述二者相结合就是 CLAHE 方法, 其全称为: Contrast Limited Adaptive Histogram Equalization.

## CLAHE 算法流程

CLAHE 算法流程主要有以下几个步骤:

1. 预处理, 如图像分块填充等;
2. 对每个分块处理, 计算映射关系, 计算映射关系时使用了对比度限制;
3. 使用插值方法得到最后的增强图像;

其处理流程可以用如下示意图表示:

![](https://gitee.com/yfor1008/pictures/raw/master/stepsCLAHE.png)

## 实现及效果

这里使用matlab实现了该算法, 实现过程参考了: [Contrast Limited Adaptive Histogram Equalization (CLAHE) - File Exchange - MATLAB Central (mathworks.com)](https://www.mathworks.com/matlabcentral/fileexchange/22182-contrast-limited-adaptive-histogram-equalization-clahe) 及matlab源码 `adapthisteq`.

以下为几组测试结果:

![20180727214122483_HE_CLAHE](https://gitee.com/yfor1008/pictures/raw/master/20180727214122483_HE_CLAHE.jpg)

从左往右以此为: 原图, HE, CLAHE, 从图中可以看到, CLAHE不仅实现了图像细节的增强, 还抑制了背景噪声.

![test_HE_CLAHE](https://gitee.com/yfor1008/pictures/raw/master/test_HE_CLAHE.jpg)

从左往右以此为: 原图, HE, CLAHE, 从图中可以看到, CLAHE实现了对细节的增强且没有使得图像过度增强.

## 关于关键步骤的说明

### 关于双线性插值

1. 对于每个分块都是将其分成 4 个子块, 然后每个子块与其相邻块的子块重新构成一个分块;
2. 对于新构成的块使用双线性插值得到增强后的图像;
3. 对于第1行的上面一行子块仅需考虑相邻行的上面一行子块, 最后行, 第1列及最后列同理;
4. 对于4个角上的子块, 直接使用本身所在块的映射关系, 不需要进行插值;

如下图所示:

![](https://gitee.com/yfor1008/pictures/raw/master/clahe_interpolation.png)

### 关于限制对比度

CLAHE 中使用的方法是不断地循环, 直到将所有截断后多余的像素都添加到直方图中. 这种方法实现过程比较复杂, 个人认为可以简化, 如:

1. 截断后直接丢弃;
2. 截断后直接均匀添加到直方图所有的bin上;

**上述2种方法对对比度影响不大, 但对图像亮度有一点点影响**, 如下图所示为上述方法1与原始CLAHE方法的对比结果, 第1行为原始CLAHE, 第2行为截断后直接丢弃方法, 第1列到第3列使用的截断参数依次为: 0.01, 0.03, 0.05.

![](https://gitee.com/yfor1008/pictures/raw/master/20180727214122483_clipLimit_cut_0.01_0.03_0.05.jpg)

从图中可看到, **对图像结果影响较大的参数是截断阈值, 而不是是否将截断后的数据添加到直方图的每个bin上**. 如下图所示为另外一组测试结果, 从左到右依次为: 原始图像, 阈值0.01, 阈值0.03, 阈值0.05.

![](https://gitee.com/yfor1008/pictures/raw/master/test_clipLimit_0.01_0.03_0.05.jpg)

### 关于预处理

需对图像进行填充, 为方便进行插值, 填充后图像的每个分块都必须为2的整数倍, 要不然不方便对每个块划分为4个子块.

### 关于直方图分布类型

在查看 matlab 源码时, 里面使用了3种分布类型: 

- uniform: CLAHE 使用的方法
- rayleigh: 代码中说是适用于水下(underwater)图像
- exponential: 没有相关说明

这里测试对比了 `uniform` 和 `rayleigh` , 如下所示为水下图像测试结果(正常图像测试几乎没有差别, 这里不进行展示了):

![](https://gitee.com/yfor1008/pictures/raw/master/8682-before_uniform_rayleigh.jpg)

从左到右依次为: 原图,  `uniform` 和 `rayleigh` , 目前没有看出二者的本质区别. 

不过这张图像来源: [Computer vision algorithm removes the water from underwater images » Behind the Headlines - MATLAB & Simulink (mathworks.com)](https://blogs.mathworks.com/headlines/2020/01/20/computer-vision-algorithm-removes-the-water-from-underwater-images/), 作者提出了一种 `Sea-thru` 方法, 效果不错, 这里下mark一下, 后面有时间在研究研究, 效果如下所示:

![](https://gitee.com/yfor1008/pictures/raw/master/8682-after.jpg)

## 参考

1. [Contrast Limited Adaptive Histogram Equalization (CLAHE) - File Exchange - MATLAB Central (mathworks.com)](https://www.mathworks.com/matlabcentral/fileexchange/22182-contrast-limited-adaptive-histogram-equalization-clahe)
2. [Image Enhancement - CLAHE - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/150381937)
3. [CLAHE (Contrast Limited Adaptive Histogram Equalization) (amroamroamro.github.io)](http://amroamroamro.github.io/mexopencv/opencv/clahe_demo_gui.html)
4. [wangyanckxx/Single-Underwater-Image-Enhancement-and-Color-Restoration: Single Underwater Image Enhancement and Color Restoration, which is Python implementation for a comprehensive review paper "An Experimental-based Review of Image Enhancement and Image Restoration Methods for Underwater Imaging" (github.com)](https://github.com/wangyanckxx/Single-Underwater-Image-Enhancement-and-Color-Restoration)

