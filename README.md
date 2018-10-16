# SDAlgorithm
Put some algorithms that use in Objective-C on git.eg:QuickSort Algorithm,HeapSort Algorithm,MergeSort Algorithm.
```
// Quicksort Algorithm(快排算法)
/**
 * 思路：快速排序是在冒牌排序的基础上改进的方法
 1.将序列的第一个元素作为比较的基准值key
 2.从最右端开始和key值比较，找到第一个小于key的值，将该值赋值给[i]，此时j记录的是右侧第一个比key小的值的index
 3.再从最左端开始查找第一个大于key的值，并将该值赋给上面的[j]，这样就完成了一次比较，直到i == j，比较结束。
 4.此时将基准数key放到赋给[i]，此时序列被分为两组，比key值小的在左边，比key值大的放在右边，在此基础上，再分别递归两组进行排序。
 优点：速度很快 时间复杂度最好情况下是O(nlogn) 最坏情况是O(n^2)
 缺点：不稳定
 */
- (void)quicksortAlgorithm:(NSMutableArray *)numbers leftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex {
    if (leftIndex >= rightIndex) {//如果数组长度为0或1时返回
        return ;
    }

    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    
    // Use the first value as compare key
    NSInteger key = [numbers[i] integerValue];
    
    while (i < j) {
         /**** 首先从右边j开始查找比基准数小的值 ***/
        while (i < j && [numbers[j] integerValue] >= key) {
            j--;
        }
        NSLog(@"i = %ld, j = %ld , numers[%ld] = %ld",i, j, j,[numbers[j] integerValue]);
        // 如果比基准数小，则将查找到的小值调换到i的位置
        numbers[i] = numbers[j];
        
        /**** 当在右边查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 ***/
        while (i < j && [numbers[i] integerValue] <= key) {
            i++;
        }
        //如果比基准数大，则将查找到的大值调换到j的位置
        numbers[j] = numbers[i];
    }
    //将基准数放到正确位置
    numbers[i] = @(key);
    /**** 递归排序 ***/
    //排序基准数左边的
    [self quicksortAlgorithm:numbers leftIndex:leftIndex rightIndex:i - 1];
    //排序基准数右边的
    [self quicksortAlgorithm:numbers leftIndex:i + 1 rightIndex:rightIndex];
}
```
