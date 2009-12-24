class Backzilla::Store::Directory < Backzilla::Store
  def initialize(name, options)
    super(name)
    @path = options['path']
  end

  private

  def protocol
    'file'
  end

  def uri
    if @path.blank?
      fatal "Missing path option"
      exit -1
    end
    @path
  end
end

