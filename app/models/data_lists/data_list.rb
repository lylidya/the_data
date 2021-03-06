class DataList < ApplicationRecord
  serialize :parameters, Hash
  serialize :columns, Hash

  has_many :table_lists, dependent: :destroy
  has_many :table_items, through: :table_lists

  scope :published, -> { where(published: true) }

  before_create :update_parameters

  def update_parameters
    self.parameters = config_params
    self.columns = config_columns
  end

  def config_params
    params = {}
    if config_table
      config_table.method(:config).parameters.each do |param|
        params.merge! param[1] => param[0]
      end
    end
    params
  end

  def config_columns
    {}
  end

  def config_table
    @config_table ||= data_table.to_s.safe_constantize
  end

  def config_excel
    @config_excel ||= export_excel.to_s.safe_constantize
  end

end