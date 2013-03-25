# encoding: utf-8
require 'spec_helper'

describe EventSerializer do
  let(:event) { double('event') }
  it 'sorts correctly' do
    es = EventSerializer.new(event)
    [
        ['a', 0], ['Z', 25], ['Ä', 0], ['ß', 486], # 'ß => ss'
        ['-A', 0], ['ZZZZ', 17575], ['ZZZZZ', 17575], ['ZZZ', 17575],
        ['Öztemir, Dogan-Can', 10133]
    ].each do |name, secs|
      [name, es.send(:name_to_secs, name)].should eq [name, secs]
    end
  end
end