//
//  ViewController.m
//  SDAlgorithm
//
//  Created by xuelin on 2018/9/28.
//  Copyright © 2018 xuelin. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, SDSortMode) {
    SDSortModeQuicksort,// 快速排序
    SDSortModeHeapfsort,// 堆排序
    SDSortModeMergesort,// 合并排序
};

struct Node {
    int data;
    struct Node *next;
};

typedef struct Node Node;

struct Tree {
    int data;
    struct Tree *left;
    struct Tree *right;
};

typedef struct Tree Tree;


@interface SDTree : NSObject
@property (nonatomic, assign) int data;
@property (nonatomic, strong) SDTree *rightTree;
@property (nonatomic, strong) SDTree *leftTree;
@end

@implementation SDTree

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];

    NSMutableArray *numbers = @[@5, @1, @7, @4, @8, @6, @2, @9, @3].mutableCopy;
    // 指定排序方式
    label.text = [self sort:SDSortModeMergesort array:numbers];
}

- (NSString *)sort:(SDSortMode)sortMode array:(NSMutableArray *)array {
    __block NSString *sortStr = nil;
    switch (sortMode) {
        case SDSortModeQuicksort:
            sortStr = @"快速排序";
            [self quicksortAlgorithm:array leftIndex:0 rightIndex:array.count - 1];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                sortStr = [NSString stringWithFormat:@"%@ %ld", sortStr ?:@"", [obj integerValue]];
            }];
            return sortStr;
        case SDSortModeHeapfsort:
            sortStr = @"堆排序";
            [self heappsort:array];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                sortStr = [NSString stringWithFormat:@"%@ %ld", sortStr ?:@"", [obj integerValue]];
            }];
            return sortStr;
        case SDSortModeMergesort: {
            sortStr = @"归并排序";
            [self mergeSortArray:array];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                sortStr = [NSString stringWithFormat:@"%@ %ld", sortStr ?:@"", [obj integerValue]];
            }];
            return sortStr;
        }
        default:
            break;
    }
    return nil;
}

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

// Heapsort(堆排序)
/**
 * 思路：
    1.将待排序的序列n构成造一个大根堆，此时整个序列中的最大值就是对顶的根节点
    2.将根结点与末尾元素交换
    3.将剩余的n-1个序列重新构造一个大根堆，得到序列中的次小值
    4.重复执行2、3步骤即可得到一个有序序列
 */
// 1.对给定序列构建一个大根堆
- (void)creatBiggesHeap:(NSMutableArray *)list size:(NSInteger)size beginIndex:(NSInteger)beginIndex {
    NSInteger lchild = beginIndex * 2 + 1, rchild = lchild + 1;
    while (rchild < size) {
        if (list[beginIndex] >= list[lchild] && list[beginIndex] >= list[rchild]) {
            // 当前自己最大
            return;
        }
        // 如果左边最大
        if (list[lchild] > list[rchild]) {
            // 把大的值和第一个交换
            [list exchangeObjectAtIndex:beginIndex withObjectAtIndex:lchild];
            beginIndex = lchild;
        } else {
            [list exchangeObjectAtIndex:beginIndex withObjectAtIndex:rchild];
            beginIndex = rchild;
        }
        lchild = beginIndex * 2 + 1;
        rchild = lchild + 1;
        // 只有左子树且子树大于自己
        if (lchild < size && list[lchild] > list[beginIndex]) {
            [list exchangeObjectAtIndex:lchild withObjectAtIndex:beginIndex];
        }
    }
}
// 2.堆排序
- (void)heappsort:(NSMutableArray *)list {
    NSInteger i, size;
    size = list.count;
    for (i = list.count / 2 - 1; i >= 0; i--) {
        // 构建大根堆
        [self creatBiggesHeap:list size:size beginIndex:i];
    }
    // 上述步骤之后，已经构件好了一颗大根堆的完全二叉树
    while (size > 0) {
        // 将堆顶元素与最后一个元素互换位置
        [list exchangeObjectAtIndex:size - 1 withObjectAtIndex:0];
        // 此时序列中最后一个元素为最大元素 只需对除去最后一个序列进行排序即可
        size--;
        // 剩下的元素重新构建大根堆
        [self creatBiggesHeap:list size:size beginIndex:0];
    }
}

// Mergesort（归并排序） 比较稳定 时间复杂度O(nlogn)
/**
 * 思路：
    对初始序列含有n个记录序列，可看成是n个有序的子序列，每个子序列的长度为1，然后两两归并，得到n/2个长度为2或者1的有序子序列；再两两归并，......，如此反复，直到得到一个长度为n的有序序列为止，这种排序方法称为归并排序。
 */
- (void)mergeSortArray:(NSMutableArray *)array {
    //创建一个副本数组
    NSMutableArray * auxiliaryArray = [[NSMutableArray alloc]initWithCapacity:array.count];
    
    //对数组进行第一次二分，初始范围为0到array.count-1
    [self mergeSort:array auxiliary:auxiliaryArray low:0 high:array.count-1];
}
- (void)mergeSort:(NSMutableArray *)array auxiliary:(NSMutableArray *)auxiliaryArray low:(NSInteger)low high:(NSInteger)high {
    //递归跳出判断
    if (low>=high) {
        return;
    }
    //对分组进行二分
    NSInteger middle = (high - low)/2 + low;
    
    //对左侧的分组进行递归二分 low为第一个元素索引，middle为最后一个元素索引
    [self mergeSort:array auxiliary:auxiliaryArray low:low high:middle];
    
    //对右侧的分组进行递归二分 middle+1为第一个元素的索引，high为最后一个元素的索引
    [self mergeSort:array auxiliary:auxiliaryArray low:middle + 1 high:high];
    
    //对每个有序数组进行回归合并
    [self merge:array auxiliary:auxiliaryArray low:low middel:middle high:high];
}
- (void)merge:(NSMutableArray *)array auxiliary:(NSMutableArray *)auxiliaryArray low:(NSInteger)low middel:(NSInteger)middle high:(NSInteger)high {
    //将数组元素复制到副本
    for (NSInteger i=low; i<=high; i++) {
        auxiliaryArray[i] = array[i];
    }
    //左侧数组标记
    NSInteger leftIndex = low;
    //右侧数组标记
    NSInteger rightIndex = middle + 1;
    
    //比较完成后比较小的元素要放的位置标记
    NSInteger currentIndex = low;
    
    while (leftIndex <= middle && rightIndex <= high) {
        //此处是使用NSNumber进行的比较，你也可以转成NSInteger再比较
        if ([auxiliaryArray[leftIndex] integerValue] < [auxiliaryArray[rightIndex] integerValue]) {
            //左侧标记的元素小于等于右侧标记的元素
            array[currentIndex] = auxiliaryArray[leftIndex];
            currentIndex++;
            leftIndex++;
        }else{
            //右侧标记的元素小于左侧标记的元素
            array[currentIndex] = auxiliaryArray[rightIndex];
            currentIndex++;
            rightIndex++;
        }
    }
    //如果完成后左侧数组有剩余
    if (leftIndex <= middle) {
        for (NSInteger i = 0; i<=middle - leftIndex; i++) {
            array[currentIndex +i] = auxiliaryArray[leftIndex +i ];
        }
    }
}

// 反转单链表
- (void)reveseLink:(Node *)node {
    Node *currentNode, *preNode;
    currentNode = node->next;
    Node *last = NULL;
    if (currentNode) {
        preNode = currentNode->next;
        currentNode->next = last;
        last = currentNode;
        currentNode = preNode;
    }
    node->next = currentNode;
}

// 层序遍历二叉树
- (void)levelEnumTree:(SDTree *)tree {
    if (!tree) return;
    NSMutableArray<SDTree *> *mTrees = @[].mutableCopy;
    [mTrees addObject:tree];
    while (mTrees.count != 0) {
        SDTree *tree = mTrees.firstObject;
        NSLog(@"%d", tree.data);
        if (tree.leftTree) {
            [mTrees addObject:tree.leftTree];
        }
        if (tree.rightTree) {
            [mTrees addObject:tree.rightTree];
        }
        [mTrees removeObject:tree];
    }
}
// 二分法在一个有序数组中查找某个值
- (BOOL)searchTargetNum:(NSNumber *)number numberArray:(NSArray<NSNumber *> *)array {
    NSInteger min = 0;
    NSInteger max = array.count - 1;
    NSInteger mid = 0;
    while (mid < max) {
        mid = (min + max) / 2;
        if (number.integerValue == array[mid].integerValue) {
            return YES;
        } else if(number.integerValue > array[mid].integerValue) {
            min = mid + 1;
        } else if (number.integerValue < array[mid].integerValue) {
            max = mid - 1;
        }
    }
    return NO;
}
// 单链表插入某个结点
- (void)insertInLink:(Node *)link num:(int)num node:(Node *)node {
    // 如果是空链表 直接插入到头结点
    if (link == NULL) {
        link->next = node;
    }
    // 找到要插入位置的前一个结点
    int i = 0;
    Node *currentNode = link->next;
    while (i < num - 1) {
        i++;
        currentNode = currentNode->next;
    }
    node->next = currentNode->next;
    currentNode->next = node;
}

// 在单链表末尾插入一个值为value的结点
- (void)insertInLink:(Node *)link value:(int)value {
    Node insertNode = {value , NULL};
    Node *currentNode = link->next;
    if (link == NULL) {
        *link = insertNode;
    } else {
        while (currentNode->next != NULL) {
            currentNode = currentNode->next;
        }
        currentNode->next = &insertNode;
    }
}
// 反转二叉树
// 思路：反转左子树，反转右子树
- (Tree *)reverseTree:(Tree *)tree {
    if (tree == NULL) {
        return tree;
    }
    Tree *temp = tree->left;
    tree->left = tree->right;
    tree->right = temp;
    [self reverseTree:tree->left];
    [self reverseTree:tree->right];
    return tree;
}
// 判断二叉树是否是镜像
- (BOOL)isMriorTree:(Tree *)tree {
    return [self isMriorTree:tree->left right:tree->right];
}

- (BOOL)isMriorTree:(Tree *)left right:(Tree *)right {
    if (left == NULL && right == NULL) {
        return YES;
    }
    if (left == NULL || right == NULL) {
        return NO;
    }
    return [self isMriorTree:left->left right:right->right] && [self isMriorTree:left->right right:right->left];
}
// 给定二叉树输出二叉树的镜像
- (Tree *)mriorTree:(Tree *)tree {
    if (tree == NULL || (tree->left == NULL && tree->right == NULL)) {
        return tree;
    }
    Tree *tempTree = tree->left;
    tree->left = tree->right;
    tree->right = tempTree;
    if (tree->left != NULL) {
        [self mriorTree:tree->left];
    }
    if (tree->right != NULL) {
        [self mriorTree:tree->right];
    }
    return tree;
}

// 不适用中间变量交换两个值的值
- (void)swap:(int)a b:(int)b {
    // 相加
    /*
    a = a + b;
    b = a - b;
    a = a - b;
    */
    // 异或
    a = a ^ b;
    b = a ^ b;
    a = a ^ b;
}

// 两个数的最大公约数
- (int)maxCommonDivisor:(int)a b:(int)b {
    int temp = 0;
    while (a % b > 0) {
        temp = a % b;
        a = b;
        b = temp;
    }
    return b;
}

@end

