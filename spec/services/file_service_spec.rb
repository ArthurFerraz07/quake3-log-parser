# frozen_string_literal: true

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

  describe '.write' do
    let(:file_path) { 'test_file.txt' }
    let(:content) { 'This is a test content.' }

    context 'when the file does not exist' do
      it 'creates a new file and writes the content to it' do
        FileService.write(file_path, content)
        expect(File.exist?(file_path)).to be true

        file_contents = File.read(file_path)
        expect(file_contents).to eq content
      end
    end

    context 'when the file already exists' do
      before do
        File.open(file_path, 'w') { |f| f.write('Existing content') }
      end

      it 'overwrites the existing file content with the new content' do
        FileService.write(file_path, content)

        file_contents = File.read(file_path)
        expect(file_contents).to eq content
      end
    end

    after do
      File.delete(file_path) if File.exist?(file_path)
    end
  end
end
