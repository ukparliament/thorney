module GroupSortHelper
  class << self
    # Sorts the array values of a hash of objects.
    #
    # @param [Hash<Object, Array>] nodes_hash grouped key value pairs where the values are all arrays.
    # @param [Array] method_symbols array of methods as symbols to sort the values by.
    # @param [Block] block block to sort the values by.
    # Note: It is only necessary to provide one of method_symbols and block.  If both are given, the block will override the method_symbols.
    # @param [Boolean] descending optionally reverses the sort order.
    #
    # @example Sorting a hash with method_symbols.
    #
    # hash = {
    #   '1' => [#<Object @laying: #<Object @date: '21 Jul 2018'>>, #<Object @laying: #<Object @date: '21 Jun 2018'>>,  #<Object @laying: #<Object @date: '21 May 2018'>>, #<Object @laying: #<Object @date: '3 Sep 2018'>>],
    #   '2' => [#<Object @laying: #<Object @date: '21 Jun 2016'>>, #<Object>, #<Object @laying: #<Object @date: '4 Jan 2016'>>, #<Object @laying: #<Object @date: '7 Sep 2016'>>]
    #   }
    #
    # sort(hash, method_symbols: [:laying, :date])
    #   #=>
    #   '1' => [#<Object @laying: #<Object @date: '21 May 2018'>>, #<Object @laying: #<Object @date: '21 Jun 2018'>>, #<Object @laying: #<Object @date: '21 Jul 2018'>>, #<Object @laying: #<Object @date: '3 Sep 2018'>>],
    #   '2' => [#<Object @laying: #<Object @date: '4 Jan 2016'>>, #<Object @laying: #<Object @date: '21 Jun 2016'>>, #<Object @laying: #<Object @date: '7 Sep 2016'>>, #<Object>]
    #   }
    #
    # @example Sorting a hash with a block (using the previously defined hash)
    #
    #   sorting_block = proc { |node| node.try(:laying).try(:date) }
    #
    #   sort(hash, block: sorting_block)
    #      #=>
    #     '1' => [#<Object @laying: #<Object @date: '21 May 2018'>>, #<Object @laying: #<Object @date: '21 Jun 2018'>>, #<Object @laying: #<Object @date: '21 Jul 2018'>>, #<Object @laying: #<Object @date: '3 Sep 2018'>>],
    #     '2' => [#<Object @laying: #<Object @date: '4 Jan 2016'>>, #<Object @laying: #<Object @date: '21 Jun 2016'>>, #<Object @laying: #<Object @date: '7 Sep 2016'>>, #<Object>]
    #     }
    #
    # @return [Array] sorted values flattened into an array.
    def sort(nodes_hash, method_symbols: nil, block: nil, descending: false)
      return if method_symbols.nil? && block.nil?

      nil_values = nodes_hash.delete(nil) || []

      sorting_block = get_linked_value(method_symbols) if method_symbols

      sorting_block = block if block

      nodes_hash.each do |key, nodes|
        rejected, cleaned_nodes = nodes.partition { |object| sorting_block.call(object).nil? }

        next if cleaned_nodes.size == 1

        cleaned_nodes.sort! { |node1, node2| sorting_block.call(node1) <=> sorting_block.call(node2) }

        cleaned_nodes.reverse! if descending

        nodes_hash[key] = cleaned_nodes.concat(rejected)
      end

      nodes_hash.values.flatten.concat(nil_values)
    end

    # Sorts the keys of a hash.
    #
    # @param [Hash<Object, Array>] nodes_hash grouped key value pairs where the values are all arrays.
    # @param [Boolean] descending optionally reverses the sort order.
    #
    # @return [Hash] hash sorted by its keys.
    def sort_keys(nodes_hash, descending: false)
      nil_values = nodes_hash.delete(nil)

      nodes_hash = descending ? nodes_hash.sort.reverse.to_h : nodes_hash.sort.to_h

      nodes_hash[nil] = nil_values if nil_values

      nodes_hash
    end

    # Groups an array into key value pairs.
    #
    # @param [Array] nodes array of objects to group.
    # @param [Array] method_symbols array of methods as symbols to group the objects by.
    # @param [Block] block block to group the objects by.
    # Note: It is only necessary to provide one of method_symbols and block.  If both are given, the block will override the method_symbols.
    #
    # @example Grouping with method_symbols
    #
    #   array = [#<Object:1 @laying: #<Object @date: '21 May 2018'>...>, #<Object:2 @laying: #<Object @date: '21 Jun 2018'>...>, #<Object:3 @laying: #<Object @date: '21 May 2018'>...>, #<Object:4 @laying: #<Object @date: '21 May 2018'>...>, #<Object:5 @laying: #<Object @date: '21 Jan 2018'>...>, #<Object:6 @laying: #<Object @date: '21 Jun 2018'>...>, #<Object:7...>]
    #
    #   group(array, method_symbols: [:laying, :date])
    #     #=>
    #     {
    #       '21 May 2018' => [#<Object:1...>, #<Object:3...>, #<Object:4...>],
    #       '21 Jun 2018' => [#<Object:2...>, #<Object:6...>],
    #       '21 Jan 2018' => [#<Object:5...>],
    #        nil => [#<Object:7...>]
    #     }
    #
    # @example Grouping with block (using same array as previous example)
    #
    #   grouping_block = proc { |node| node.try(:laying).try(:date) }
    #
    #   group(array, block: grouping_block)
    #     #=>
    #     {
    #       '21 May 2018' => [#<Object:1...>, #<Object:3...>, #<Object:4...>],
    #       '21 Jun 2018' => [#<Object:2...>, #<Object:6...>],
    #       '21 Jan 2018' => [#<Object:5...>],
    #        nil => [#<Object:7...>]
    #     }
    #
    # @return [Hash] grouped objects with the key the grouped value and the values the objects.
    def group(nodes, method_symbols: nil, block: nil)
      return if method_symbols.nil? && block.nil?

      grouped_nodes  = {}
      grouping_block = nil

      grouping_block = get_linked_value(method_symbols) if method_symbols

      grouping_block = block if block

      nodes.each do |node|
        key = grouping_block.call(node)

        grouped_nodes[key] = [] unless grouped_nodes[key]
        grouped_nodes[key] << node
      end

      grouped_nodes
    end

    def group_and_sort(nodes, group_method_symbols: nil, group_block: nil, key_sort_descending: false, sort_method_symbols: nil, sort_block: nil, sort_descending: false)
      grouped_hash = group(nodes, method_symbols: group_method_symbols, block: group_block)
      sorted_by_keys = sort_keys(grouped_hash, descending: key_sort_descending)
      sort(sorted_by_keys, method_symbols: sort_method_symbols, block: sort_block, descending: sort_descending)
    end

    private

    # Takes the method symbols provided and calls them in a chain on the node using try to handle nil values.
    def get_linked_value(method_symbols)
      proc do |node|
        method_symbols.inject(node) { |value, method| value.try(method) }
      end
    end
  end
end
