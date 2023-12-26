require "./lib/node.rb"
require "../recursion/merge_sort.rb"
class Tree
    attr_accessor :root

    def initialize(array)
        sorted_array = merge_sort(array).uniq
        first=0
        last=(sorted_array.length)-1
        self.root = self.build_tree(sorted_array, first,last)
    end

    def build_tree(array , first, last)
        return nil if first>last
        mid = (first+last)/2
        #set root, left and right
        root=array[mid]
        left= build_tree(array,first, mid-1)
        right = build_tree(array,mid+1,last)
        return Node.new(root,left,right)
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

    def insert(value)
        self.root = self.insert_val(value)
    end

    def delete(value)
        self.root = self.delete_val(value)
    end

    def find(value, root=self.root)
        self.level_order_rec{|node| return node if node.data == value}
        puts "There is no node with the value #{value}"
    end

    def level_order_iter()
        queue=[self.root]
        result = []
        until queue.empty?
            node= queue.shift()
            queue.push(node.left) unless node.left.nil?
            queue.push(node.right) unless node.right.nil?
            if block_given?
                yield node
            else
                result.push(node.data)
            end
        end
        return result
    end
    def level_order_rec(queue=[self.root],result=[], &my_block)
        return result if queue.empty?
        node = queue.shift()
        queue.push(node.left) unless node.left.nil?
        queue.push(node.right) unless node.right.nil?
        if block_given?
            my_block.call(node)
            level_order_rec(queue, result, &my_block)            
        else
            result.push(node.data)
            level_order_rec(queue,result)
        end
        return result
    end
    def inorder(root=self.root,result=[], &my_block)
        return result if root.nil?
        inorder(root.left,result,&my_block)
        if block_given?
            my_block.call(root)
        else
            result.push(root.data)
        end
        inorder(root.right,result,&my_block)
    end
    def preorder(root=self.root,result=[], &my_block)
        return result if root.nil?
        if block_given?
            my_block.call(root)
        else
            result.push(root.data)
        end
        preorder(root.left,result, &my_block)
        preorder(root.right,result, &my_block)
    end
    def postorder(root=self.root,result=[], &my_block)
        return result if root.nil?
        postorder(root.left,result, &my_block)
        postorder(root.right,result, &my_block)
        if block_given?
            my_block.call(root)
        else
            result.push(root.data)
        end
    end
    def height(value)
        node = self.find(value)
        p get_height(node) unless node.nil?
    end

    def depth(value, depth = 0 , root = self.root)
        return nil if root.nil?
        return depth if root.data == value
       
        if value < root.data
            depth(value, depth+1, root.left)
        elsif value > root.data
            depth(value, depth+1, root.right)
        end
    end

    def balanced?()
        get_height do |left,right|
            abs_difference = (left-right).abs
            return false if abs_difference > 1
        end
        true
    end

    def rebalance()
        unless self.balanced? 
            array=self.inorder()
            self.root = build_tree(array , 0 , array.length-1)
        end
        #p self.pretty_print(self.root)
    end
    protected
    def insert_val(value,root=self.root)
        if root.nil?
            return Node.new(value)
        elsif value == root.data
            p "#{value} exists in the tree"
            return root
        end

        if value < root.data
            root.left = insert_val(value, root.left)
        else
            root.right = insert_val(value, root.right)
        end
        return root
    end
    def delete_val(value, root=self.root)
        if root.nil?
            return
        elsif value == root.data
            case [root.left,root.right]
                in [nil,nil]
                    return nil
                in [Node => a, Node => b]
                    substitute =self.farthest_left(root.right)
                    root.right = delete_val(substitute,root.right)
                    root.data = substitute
                in [a,b]
                    child= a.nil? ? b : a
                    return child
            end
        end

        if value < root.data
            root.left = delete_val(value,root.left)
        else
            root.right = delete_val(value,root.right)
        end
        return root
    end
    def farthest_left(tree,data=nil)
        return data if tree.nil?
        data=tree.data
        return farthest_left(tree.left,data)
    end
    def get_height(node = self.root, height= -1, &my_block)
        return height if node.nil?
        left = get_height(node.left,height+1, &my_block)
        right = get_height(node.right,height+1, &my_block)
        if block_given?
            my_block.call(left, right)
        else
        end
        left<right ? right : left
    end
end