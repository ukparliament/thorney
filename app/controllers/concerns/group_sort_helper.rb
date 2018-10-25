module GroupSortHelper
  class << self
    # Sorts the array values of a hash of objects.
    #
    # @param [Hash<Object, Array>] nodes_hash grouped key value pairs where the values are all arrays.
    # @param [Array] method_symbols array of methods as symbols to sort the values by.
    # @param [Block] block block to sort the values by.
    # @param [Boolean] descending optionally reverses the sort order.
    #
    # @return [Array] sorted values flattened into an array.
    def sort(nodes_hash, method_symbols: nil, block: nil, descending: false)
      nil_values = nodes_hash.delete(nil) || []

      nodes_hash.each do |key, nodes|
        sorting_block = get_linked_value(method_symbols) if method_symbols

        sorting_block = block if block

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
    #
    # @return [Hash] grouped objects with the key the grouped value and the values the objects.
    def group(nodes, method_symbols: nil, block: nil)
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

    private

    def get_linked_value(method_symbols)
      proc do |node|
        method_symbols.inject(node) { |value, method| value.try(method) }
      end
    end
  end
end
