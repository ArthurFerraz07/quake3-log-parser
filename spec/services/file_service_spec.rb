# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe FileService do
  describe '.readlines' do
    context 'when the file exists' do
      let(:file_path) { 'test.txt' }
      let(:file_content) { "Line 1\nLine 2\nLine 3" }

      before do
        File.write(file_path, file_content)
      end

      it 'reads lines from the file' do
        lines = FileService.readlines(file_path)
        expect(lines).to eq(file_content.split("\n"))
      end

      after do
        File.delete(file_path)
      end
    end

    context 'when the file does not exist' do
      let(:non_existent_file_path) { 'non_existent.txt' }

      it 'raises an error' do
        expect { FileService.readlines(non_existent_file_path) }.to raise_error(Errno::ENOENT)
      end
    end
  end
end
