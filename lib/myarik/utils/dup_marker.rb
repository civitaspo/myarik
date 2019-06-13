class Myarik::Utils
  module DupMarker

    MAGIC_SEP = "\c_"

    def with_dup_mark(s)
      s + MAGIC_SEP + SecureRandom.uuid
    end

    def without_dup_mark(s)
      s.split(MAGIC_SEP).first
    end

  end
end
