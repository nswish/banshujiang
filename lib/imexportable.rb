module ImExportable
    def export
      YAML.dump self.all
    end

    def import
      self.delete_all

      YAML.load(doc).each do |item|
        inst = self.new
        inst.initialize_dup item
        inst.id = item.id
        inst.save
        inst.created_at = item.created_at
        inst.updated_at = item.updated_at
        inst.save
      end
    end
end
