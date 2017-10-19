namespace :get_phrase do
  desc "言い訳フレーズの収集"

  task :get_phrase_when_delay => :environment do
    agent = Mechanize.new
    next_url = ""
    current_page = agent.get("http://atsume.goo.ne.jp/lnuTCEsc0fQe")
    elements = current_page.search(".section p")
    elements.each do |ele|
      phrase = Phrase.new
      # phrase.word = ele.inner_text
      # phrase.save
      phrase.word = ele.inner_text
    end

  end
end
