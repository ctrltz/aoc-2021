require 'set'

EASY_COUNT = { 1 => 2, 7 => 3, 4 => 4, 8 => 7}
SEGMENTS = Set['a', 'b', 'c', 'd', 'e', 'f', 'g']
DIGITS = {
  "abcefg" => "0",
  "cf" => "1",
  "acdeg" => "2",
  "acdfg" => "3",
  "bcdf" => "4",
  "abdfg" => "5",
  "abdefg" => "6",
  "acf" => "7",
  "abcdefg" => "8",
  "abcdfg" => "9"
}

def segcount(digits)
  return digits.map{|d| d.length()}
end

def ssnot(segset)
  return SEGMENTS - segset
end

def ss(chunk)
  return chunk.scan(/\w/).to_set
end

def unwrap(segset)
  raise "Expect a single character" unless segset.length() == 1
  return segset.to_a.first
end

class Decoder
  def initialize
    @enc_mapping = {}
    @dec_mapping = {}
  end

  def fit(line)
    chunks = line.split()
    enc = Array.new(10)
    counts = segcount(chunks)    

    # assign easy digits
    EASY_COUNT.each do |key, value|
      enc[key] = chunks[counts.index(value)]
    end

    # top segment (a) = 7 & not 1
    @enc_mapping["a"] = unwrap(ss(enc[7]) & ssnot(ss(enc[1])))

    # middle segment (d) = intersection of 5-segment digits and 4
    intersection_5seg = chunks.select{|s| s.length() == 5}
                              .inject(SEGMENTS) {
                                |product, s| product & ss(s)
                              }             
    @enc_mapping["d"] = unwrap(intersection_5seg & ss(enc[4]))

    # bottom segment (g) = intersection of 5-segment digits - mappings for a and d
    mapping_ad = @enc_mapping["a"] + @enc_mapping["d"]
    @enc_mapping["g"] = unwrap(intersection_5seg & ssnot(ss(mapping_ad)))

    # top left segment (b) = 4 & not 1 & not d
    mapping_1d = @enc_mapping["d"] + enc[1]
    @enc_mapping["b"] = unwrap(ss(enc[4]) & ssnot(ss(mapping_1d)))

    # top right segment (c) = union of negations of 6-segment digits & 1
    union_neg6seg = chunks.select{|s| s.length() == 6}
                          .inject(Set.[]) {
                            |product, s| product | ssnot(ss(s))
                          }
    @enc_mapping["c"] = unwrap(union_neg6seg & ss(enc[1]))

    # bottom left segment (e) = union of negations of 6-segment digits & not cd
    mapping_cd = @enc_mapping["c"] + @enc_mapping["d"]
    @enc_mapping["e"] = unwrap(union_neg6seg & ssnot(ss(mapping_cd)))

    # bottom right segment (f) = 1 & not c
    @enc_mapping["f"] = unwrap(ss(enc[1]) & ssnot(ss(@enc_mapping["c"])))

    @enc_mapping.each do |key, value|
      @dec_mapping[value] = key
    end
  end

  def transform(enc)
    dec = enc.scan(/\w/)
             .map{|c| @dec_mapping[c]}
             .sort
             .reduce(:+)
    return DIGITS[dec]
  end
end

class Solver
  def initialize(filename)
    @lines = []
    File.foreach(filename) {|line| @lines.append(line)}
  end

  def part1
    sum = 0
    @lines.each do |line|
      counts = segcount(line.split(" | ")[1].split())
      easy = counts.map{|c| sum += (EASY_COUNT.values.include? c) ? 1 : 0}
    end
    puts "Answer to Part 1: #{sum}"
  end

  def part2
    sum = 0
    @lines.each do |line|
      decoder = Decoder.new
      parts = line.split(" | ")
      decoder.fit(parts[0])
      sum += parts[1].split()
                     .map {|p| decoder.transform(p)}
                     .reduce(:+)
                     .to_i
    end
    puts "Answer to Part 2: #{sum}"
  end
end

if __FILE__ == $0
  if ARGV.length() != 1
    puts "Usage: #{$0} <filename>"
    exit(1)
  end
  
  filename = ARGV[0]
  solver = Solver.new(filename)
  solver.part1
  solver.part2
end
