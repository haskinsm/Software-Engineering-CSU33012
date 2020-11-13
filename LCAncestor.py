# A binary tree node 
class Node: 
    # Constructor to create a new binary node 
    def __init__(self, val): 
        self.val =  val 
        self.left_Node = None 
        self.right_Node = None
        self.Parent = None

class BinaryTree:
  def __init__(self, val):
    self.root = Node(val)

def lowest_common_ancestor(node1,node2):
    ancestor_node1 = [] #use slice to store ancestor of node1
    curr = node1
    while(curr!=None):
        curr = curr.Parent
        if(curr != None):
            ancestor_node1.append(curr) #Add ancestors of Node 1

    curr = node2
    while(curr!=None):
        curr = curr.Parent
        for i in range(0, len(ancestor_node1)): #find out if the most immediate ancestor of node 1 is also the common ancestor of node2
            if(ancestor_node1[i]==curr):
                print ("The nodes ",node1.val," and ",node2.val," have ",curr.val," as their lowest common ancestor")
                return curr  
    return None

def main():

  # making the Binary tree structure 
  BST = BinaryTree('d')

  BST.root.left_Node = Node('c')
  BST.root.left_Node.Parent = BST.root
  BST.root.right_Node = Node('e')
  BST.root.right_Node.Parent = BST.root

  BST.root.left_Node.left_Node = Node('a')
  BST.root.left_Node.left_Node.Parent = BST.root.left_Node
  BST.root.left_Node.right_Node = Node('b')
  BST.root.left_Node.right_Node.Parent = BST.root.left_Node

  BST.root.right_Node.left_Node = Node('f')
  BST.root.right_Node.left_Node.Parent = BST.root.right_Node
  BST.root.right_Node.right_Node = Node('g')
  BST.root.right_Node.right_Node.Parent = BST.root.right_Node
  
  result = lowest_common_ancestor(BST.root.right_Node.left_Node,BST.root.right_Node.right_Node)
  
if __name__ == "__main__":
  main()
