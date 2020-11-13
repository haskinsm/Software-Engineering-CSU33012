import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.Arrays;

import org.junit.jupiter.api.Test;

class LowestCommonAncestorTest {
  
	@Test
	void testBinaryTree() {
		LowestCommonAncestor myLCAClass = new LowestCommonAncestor();
		LowestCommonAncestor.BinaryTree myTree = myLCAClass.new BinaryTree();//myTee constructed & shown below in comments
		myTree.root = new BinaryTreeNode(1);                         //1
		myTree.root.left = new BinaryTreeNode(2);                  //2   3
        myTree.root.right = new BinaryTreeNode(3);               //4  5  6 7
        myTree.root.left.left = new BinaryTreeNode(4);    
        myTree.root.left.right = new BinaryTreeNode(5); 
        myTree.root.right.left = new BinaryTreeNode(6); 
        myTree.root.right.right = new BinaryTreeNode(7); 
        
        assertEquals(5, myTree.root.left.right.data);
	}

	@Test
	void testBinaryTreeLCA() {
		LowestCommonAncestor myLCAClass = new LowestCommonAncestor();
		LowestCommonAncestor.BinaryTree myTree = myLCAClass.new BinaryTree();//myTee constructed & shown below in comments
		myTree.root = new BinaryTreeNode(1);                         //1
		myTree.root.left = new BinaryTreeNode(2);                  //2   3
        myTree.root.right = new BinaryTreeNode(3);               //4  5  6 7
        myTree.root.left.left = new BinaryTreeNode(4);    
        myTree.root.left.right = new BinaryTreeNode(5); 
        myTree.root.right.left = new BinaryTreeNode(6); 
        myTree.root.right.right = new BinaryTreeNode(7); 
        
        assertEquals(2, myTree.LCA(myTree.root, myTree.root.left.left,myTree.root.left.right).data);
        assertEquals(1 , myTree.LCA(myTree.root, myTree.root.left.left,myTree.root.right.left).data);
        assertEquals(1 , myTree.LCA(myTree.root, myTree.root.right, myTree.root.left.left).data);
        assertEquals(2 , myTree.LCA(myTree.root, myTree.root.left, myTree.root.left.left).data);
        assertEquals(1 , myTree.LCA(myTree.root, myTree.root, myTree.root.left.left).data);
	}
	
	@Test
	void testEmptyBTree() {
		LowestCommonAncestor myLCAClass = new LowestCommonAncestor();
		LowestCommonAncestor.BinaryTree myTree = myLCAClass.new BinaryTree();
		
		assertEquals(null, myTree.root);
		assertEquals(null, myTree.LCA(myTree.root, null, null)); 
		//Not possible to do myTree.root.right as will cause Null Pointer exception
	}
	
	@Test
	void testNodeNotInBTreeCall() { //Will cause errors if its 'parent' node does not exist too
		LowestCommonAncestor myLCAClass = new LowestCommonAncestor();
		LowestCommonAncestor.BinaryTree myTree = myLCAClass.new BinaryTree();
		
		myTree.root = new BinaryTreeNode(1);  
		assertEquals(null, myTree.root.right);
		assertEquals(null, myTree.root.left);		
	}
	
	@Test
	void testNotIntNodeData() { //Won't work for double, but seems to work for chars for some reason
		LowestCommonAncestor myLCAClass = new LowestCommonAncestor();
		LowestCommonAncestor.BinaryTree myTree = myLCAClass.new BinaryTree();
		myTree.root = new BinaryTreeNode('c');  
		assertEquals('c', myTree.root.data);
	} 
	
	@Test
	void testDAG() {
		LowestCommonAncestor myLCAClass = new LowestCommonAncestor();
		LowestCommonAncestor.DAGTree myTree = myLCAClass.new DAGTree(); //myTee constructed & shown below in comments
		
		assertEquals(null, myTree.root);
		 /* Node(<parents>)   
		 *                1
		 *         2(1)        3(1)
		 *         4(2)
		 *      5(4)     6(4,3)       7(3)
		 * 
		 */
		myTree.addNode(null, 1);
		assertEquals(1, myTree.root.data);
		
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root)), 2);
		assertEquals(2, myTree.root.successors.get(0).data);
		
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root)), 3);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root.successors.get(0))), 4);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root.successors.get(0).successors.get(0))), 5);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root.successors.get(0).successors.get(0), myTree.root.successors.get(1))), 6);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root.successors.get(1))), 7);
		
		assertEquals(4, myTree.root.successors.get(0).successors.get(0).data);
		assertEquals(6, myTree.root.successors.get(0).successors.get(0).successors.get(1).data);
		assertEquals(6, myTree.root.successors.get(1).successors.get(0).data);
		assertEquals(7, myTree.root.successors.get(1).successors.get(1).data);
	} 
	 
	@Test
	void testDAGLCA() {
		LowestCommonAncestor myLCAClass = new LowestCommonAncestor();
		LowestCommonAncestor.DAGTree myTree = myLCAClass.new DAGTree(); //myTee constructed & shown below in comments
		
		/*  Node(<parents>)   
		 *                1
		 *         2(1)        3(1)
		 *         4(2)
		 *      5(4)     6(4,3)       7(3)
		 * 
		 */
		myTree.addNode(null, 1);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root)), 2);	
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root)), 3);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root.successors.get(0))), 4);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root.successors.get(0).successors.get(0))), 5);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root.successors.get(0).successors.get(0), myTree.root.successors.get(1))), 6);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root.successors.get(1))), 7);
		
		//LCA of 1 and 2 should be 1
		assertEquals(1, myTree.DAGLCA(myTree, myTree.root, myTree.root.successors.get(0)).data);
		//LCA of 3 and 3 should be 3
		assertEquals(3, myTree.DAGLCA(myTree, myTree.root.successors.get(1), myTree.root.successors.get(1)).data);
		//LCA of 2 and 3 should be 1
		assertEquals(1, myTree.DAGLCA(myTree, myTree.root.successors.get(0), myTree.root.successors.get(1)).data);
		//LCA of 6 and 7 should be 3
		assertEquals(3, myTree.DAGLCA(myTree, myTree.root.successors.get(1).successors.get(0), myTree.root.successors.get(1).successors.get(1)).data);
		//LCA of 5 AND 6 should be 4
		assertEquals(4, myTree.DAGLCA(myTree, myTree.root.successors.get(0).successors.get(0).successors.get(0), myTree.root.successors.get(0).successors.get(0).successors.get(1)).data);
		//LCA of 4 and 7 should be 1
		assertEquals(1, myTree.DAGLCA(myTree, myTree.root.successors.get(0).successors.get(0), myTree.root.successors.get(1).successors.get(1)).data);
	}
	
	@Test
	void testDAGLCAWithUnbalancedBinaryTree() {
		LowestCommonAncestor myLCAClass = new LowestCommonAncestor();
		LowestCommonAncestor.DAGTree myTree = myLCAClass.new DAGTree(); 
		
		/*
		 * Node(<Parent>)
		 * 			1
		 * 		2		3
		 *   4	  5    6
		 */
		
		myTree.addNode(null, 1);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root)), 2);	
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root)), 3);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root.successors.get(0))), 4);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root.successors.get(0))), 5);
		myTree.addNode(new ArrayList<DAGTreeNode>(Arrays.asList(myTree.root.successors.get(1))), 6);
		
		//LCA of 2 and 3 should be 1
		assertEquals(1, myTree.DAGLCA(myTree, myTree.root.successors.get(0), myTree.root.successors.get(1)).data);
		//LCA of 4 and 5, should be 2
		assertEquals(2, myTree.DAGLCA(myTree, myTree.root.successors.get(0).successors.get(0), myTree.root.successors.get(0).successors.get(1)).data);
		//LCA of 5 and 3 should be 1
		assertEquals(1, myTree.DAGLCA(myTree, myTree.root.successors.get(0).successors.get(1), myTree.root.successors.get(1)).data);
		//LCA of 5 and 6 should be 1
		assertEquals(1, myTree.DAGLCA(myTree, myTree.root.successors.get(0).successors.get(1), myTree.root.successors.get(1).successors.get(0)).data);
	}
}
