import java.util.ArrayList;


//LCA = Lowest Common Ancestor. Presume not allowed to use BST, but would be quicker if was allowed to use that data structure.
class DAGTreeNode{
	int data;
	ArrayList<DAGTreeNode> successors;

	DAGTreeNode(int data){
		this.data = data;
		successors = new ArrayList<DAGTreeNode>();
	}
}

class BinaryTreeNode{
	int data;
	BinaryTreeNode right, left;
	
	BinaryTreeNode(int data){
		this.data = data;
		this.right = this.left = null;
	}
}

public class LowestCommonAncestor {
	
	public boolean AandBFound;
	
	public class BinaryTree{
		BinaryTreeNode root; 
		
		//Say if b is higher up than a, and on the same side of the tree as a, b will be LCA
		public BinaryTreeNode LCA( BinaryTreeNode root, BinaryTreeNode a, BinaryTreeNode b) {
			if( root == null) {
				return null;
			}
			if( root == a || root ==b) {   
				return root; 
			}
			
			BinaryTreeNode left = LCA(root.left, a, b);
			BinaryTreeNode right = LCA(root.right, a, b);
			
			
			//If left && right are not null, this 'root' is LCA for a and b
			if( left!=null && right!=null) {
				return root;
			}
			if(left == null) {
				return right;
			}
			else {
				return left;
			}
		}
	}
	
	
	public class DAGTree{
		DAGTreeNode root = null; 
		
		public void addNode(ArrayList<DAGTreeNode> parentsOfNode, int key) {
			DAGTreeNode node = new DAGTreeNode(key);
			if(root == null) {
				root = node;
			}
			if(	parentsOfNode != null) { // If null does not necessarily mean its the root of the tree/graph (I think)
				for(DAGTreeNode parent : parentsOfNode) {
					if(parent != null) { //Might not need this check, or maybe if it is null could create the parent node
						parent.successors.add(node);
					}
				}
			}
		}
		
		//Didn't end up using the below method anywhere, but left it in in case becomes useful in the future
		public ArrayList<DAGTreeNode> getSuccessors(DAGTreeNode node){
			if(node != null) {
				return node.successors;
			}
			return null;
		}
		
		//Note: a or b can be the LCA of the pair 
		public DAGTreeNode DAGLCA(DAGTree myTree, DAGTreeNode a, DAGTreeNode b) {
			DAGTreeNode headMyTree = myTree.root;
			AandBFound = false; 
			
			//If any parameters are null, null is returned
			if( myTree == null || a == null || b == null) {
				return null;
			}
			//If any of the nodes are the head/root, returns the root
			if( headMyTree.data == a.data || headMyTree.data == a.data) {
				return headMyTree;
			}
			//If the nodes are the same, returns a
			if( a.data == b.data) {
				return a;
			}
			return inSubtree(headMyTree, a, b);
		}
		
		// If a LCA cannot be found null is returned, but because of my implementation
		// would get null pinter errors (In my tests). Perhaps a better way to go about this problem would
		// have been to take in keys rather than nodes, and return the LCA's key.
		// Would need an extra method to find the node which has the key x though.
		// Could then have meaningful output if null is returned rather than null pointer exceptions
		// I get the null pointer errors from assertEquals(......., null.data) in my tests. (When the LCA is Null)
		
		public DAGTreeNode inSubtree(DAGTreeNode node, DAGTreeNode a, DAGTreeNode b) {
			boolean foundA = false;
			boolean foundB = false;
			for(int i = 0; i < node.successors.size(); i++) {
				DAGTreeNode subtree = inSubtree(node.successors.get(i), a, b);
				
				if( subtree != null) {
					// The immediately below if statement is needed so that the correct answer is returned
					// if both A and B have been found
					// The bottom if statement will not exit the method fully, but will 
					// set subtree = node (node here is the LCA, i.e. the correct answer)
					// so it is then necessary to return the subtree which will fully exit the method so to say.
					if( AandBFound) {
						return subtree;
					}
					if( subtree.data == a.data) {
						foundA = true;
					}
					if( subtree.data == b.data) {
						foundB = true;
					}
					if( foundA && foundB) {
						AandBFound = true;
						return node;
					}
				}

			}
		
			if( node.data == a.data) {
				return node;
			}
			
			if( node.data == b.data) {
				return node;
			}
			
			//The below if statements are needed to ensure that it is recorded that say nodeA is in the subtree
			//So when say node a is returned, foundA will be true for all its ancestors.
			if( foundA) { 
				return a;
			}
			if(foundB) {
				return b;
			}
			return null;
		}		
	}
}


