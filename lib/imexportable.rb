module ImExportable
=begin
  def export
    YAML.dump self.all
  end

  def import(doc)
    self.delete_all

    ActiveRecord::Base.transaction do
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
=end

  def export
    self.all.map do |rec|
      rec.to_json
    end
  end

  def import(doc)
    self.delete_all

    ActiveRecord::Base.transaction do
      JSON.load(doc).each do |item|
        inst = self.new

        JSON.load(item).each do |k, v|
          inst.send (k+'=').to_sym, v
        end

        inst.save
      end
    end
  end

end
