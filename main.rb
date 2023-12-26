require "./lib/tree.rb"

tree1= Tree.new(Array.new(15) { rand(1..100) })
p tree1.balanced?
p tree1.level_order_rec
p tree1.preorder
p tree1.inorder
p tree1.postorder
tree1.insert(200)
tree1.insert(112)
tree1.insert(108)
p tree1.balanced?
tree1.rebalance
p tree1.balanced?
p tree1.level_order_rec
p tree1.preorder
p tree1.inorder
p tree1.postorder