########
#      #
# Bob  #
#      #
########

class Bob
  def hey(message_string)
    message = Message.new(message_string)
    bob_responder = BobResponder.new
    bob_responder.response_for(message.tone)
  end
end

##################
#                #
# Bob Responder  #
#                #
##################

class BobResponder
  def response_for(tone)
    response[tone]
  end

private

  def response
    {
      Silence => 'Fine. Be that way!',
      Yelling => 'Whoa, chill out!',
      Asking => 'Sure.',
      Everything => 'Whatever.'
    }
  end
end

############
#          #
# Message  #
#          #
############

class Message
  def initialize(message)
    @message = message
  end
  
  def tone
    ToneDetector.detect_tone_of @message
  end
end


#################
#               #
# ToneDetector  #
#               #
#################

class ToneDetector
  def self.detect_tone_of(message)
    tone_detector = self.new(message)
    tone_detector.detect_tone
  end
  
  def initialize(message)
    @message = message
  end

  def detect_tone
    with_each_tone do |tone|
      return tone if in_tone?(tone)
    end
  end

private

  def in_tone?(tone_class)
    tone = tone_class.new(@message)
    tone.matches_message?
  end

  def with_each_tone
    tones.each do |tone|
      yield tone
    end
  end

  def tones
    [Silence,Yelling,Asking,Everything]
  end  
end

#########
#       #
# Tone  #
#       #
#########

class Tone
  def initialize(message)
    @message = message
  end
end

class Silence < Tone
  def matches_message?
    @message.to_s.strip.empty?
  end
end

class Yelling < Tone
  def matches_message?
    @message.upcase == @message && @message.downcase != @message
  end
end
  
class Asking < Tone
  def matches_message?
    @message.end_with? '?'
  end
end

class Everything < Tone
  def matches_message?
    true
  end
end

