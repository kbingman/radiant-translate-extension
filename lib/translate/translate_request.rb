class TranslateRequest
  
  ActionController::Request.class_eval {  
    # for unusual default mappings, i.e. ones that do not match the typical 'ab' => 'ab-AB' pattern
    # examples: en-UK, en-US, es-MX
    @@mappings = {
      'en' => 'en-US'
    }
    cattr_accessor :mappings

    # when the language is requested, we'll standardize how we'd like it returned
    # currently, we're defaulting to the four letter variety. However, the normal
    # <r:translator:content /> and <r:translator:title /> tags chop off the end and only
    # use the first two letters of the requested language
    def proper_language(two_letter)
      if two_letter.length == 2
        if @@mappings[two_letter]
          @@mappings[two_letter]
        else
          two_letter.downcase + '-' + two_letter.upcase
        end
      else
        if m = two_letter.match(/^[a-zA-Z]{2}\-([a-zA-Z]{2})?/)
          splitter = m[0].split('-')
          splitter[0].downcase + '-' + splitter[1].upcase
        else
          # otherwise, send back the default
          TranslatorExtension.defaults[:language]
        end
      end
    end

    # return the requested language of the current request
    def language
      return proper_language(self.parameters[:language]) if self.parameters[:language]
      return session_lang = proper_language(self.session[:language]) if self.session[:language]
      
      lang = self.env['HTTP_ACCEPT_LANGUAGE'] || ''
      m = lang.match(/^[a-zA-Z]{2}(\-[a-zA-Z]{2})?/)

      return TranslatorExtension.defaults[:language] unless m 
      match = m[0]
      return proper_language(match)
    end

    # turn the requested language into a proper suffix for the translator extension tags
    def suffixize(lang)
      lang.blank? ? "" : "_#{lang}"
    end
  }
  
end