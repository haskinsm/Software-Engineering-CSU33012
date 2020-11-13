import unittest
import LCAncestor


class test_LCA(unittest.TestCase):

    def test_BST(self):
        BST = LCAncestor.BinaryTree('d')

        BST.root.left_Node = LCAncestor.Node('c')
        BST.root.left_Node.Parent = BST.root
        BST.root.right_Node = LCAncestor.Node('e')
        BST.root.right_Node.Parent = BST.root

        BST.root.left_Node.left_Node = LCAncestor.Node('a')
        BST.root.left_Node.left_Node.Parent = BST.root.left_Node
        BST.root.left_Node.right_Node = LCAncestor.Node('b')
        BST.root.left_Node.right_Node.Parent = BST.root.left_Node

        BST.root.right_Node.left_Node = LCAncestor.Node('f')
        BST.root.right_Node.left_Node.Parent = BST.root.right_Node
        BST.root.right_Node.right_Node = LCAncestor.Node('g')
        BST.root.right_Node.right_Node.Parent = BST.root.right_Node
        self.assertEqual(BST.root.val, 'd', "Should be d")

    def test_LCA(self):
        BST = LCAncestor.BinaryTree('d')

        BST.root.left_Node = LCAncestor.Node('c')
        BST.root.left_Node.Parent = BST.root
        BST.root.right_Node = LCAncestor.Node('e')
        BST.root.right_Node.Parent = BST.root

        BST.root.left_Node.left_Node = LCAncestor.Node('a')
        BST.root.left_Node.left_Node.Parent = BST.root.left_Node
        BST.root.left_Node.right_Node = LCAncestor.Node('b')
        BST.root.left_Node.right_Node.Parent = BST.root.left_Node

        BST.root.right_Node.left_Node = LCAncestor.Node('f')
        BST.root.right_Node.left_Node.Parent = BST.root.right_Node
        BST.root.right_Node.right_Node = LCAncestor.Node('g')
        BST.root.right_Node.right_Node.Parent = BST.root.right_Node
        self.assertEqual(LCAncestor.lowest_common_ancestor(BST.root.right_Node.left_Node,BST.root.right_Node.right_Node).val, 'e', "Should be e")

if __name__ == '__main__':
    unittest.main()