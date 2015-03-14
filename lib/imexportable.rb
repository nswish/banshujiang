module ImExportable
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

  def refreshCount(doc)
    ActiveRecord::Base.transaction do
      JSON.load(doc).each do |item|
        item = JSON.load(item)
        inst = self.find item["id"]
        inst.send "download_count=".to_sym, item["download_count"]
        inst.save
      end
    end
  end
end
