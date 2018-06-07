require_relative '../rails_helper'

describe BaseSerializer do
  context '#to_h' do
    it 'raises an error if called in BaseSerializer' do
      expect { subject.to_h }.to raise_error('You must implement #content')
    end
  end

  context '#to_yaml' do
    it 'raises an error if called in BaseSerializer' do
      expect { subject.to_yaml }.to raise_error('You must implement #content')
    end
  end

  context '#t' do
    it 'wraps the arguments for translation' do
      args = 'text or link'
      expect(subject.t(args)).to eq(I18n.t('text or link'))
    end
  end

  context '#link_to' do
    it 'wraps the arguments to create a text link' do
      body = 'text or link'
      url = '//link'
      html_options = {}
      expect(subject.link_to(body, url, html_options = {})).to eq("<a href=\"//link\">text or link</a>")
    end
  end

  context '#dasherize_keys' do
    it 'correctly transforms the hash\'s keys' do
      original_hash = { hello_one: { hello_two: 123 } }
      expected_hash = { 'hello-one' => { 'hello-two' => 123 } }

      expect(subject.dasherize_keys(original_hash)).to eq expected_hash
    end
  end
end
