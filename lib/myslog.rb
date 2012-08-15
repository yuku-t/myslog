#
# MySlog
#
# Copyright (C) 2012 Yuku TAKAHASHI
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require "time"

class MySlog
  def parse(text)
    divide(text.split("\n")).map {|r| parse_record(r) }
  end

  def divide(lines)
    records = []

    line = lines.shift

    while line
      record = []

      if line.start_with? "# Time:"
        record << line
        record << lines.shift  # user@host
        record << lines.shift  # query time
      else
        record << line         # user@host
        record << lines.shift  # query time
      end

      sql = []
      while (line = lines.shift) != nil && !line.start_with?("#")
        sql << line.strip
      end
      record << sql.join(" ")

      records << record
    end

    records
  end

  def parse_record(records)
    response = {}

    record = records.shift
    if record.start_with? "# Time:"
      date = record[8..-1].strip
      response[:date] = Time.parse(date)

      record = records.shift
    else
      response[:date] = nil
    end

    elems = record.split(/( )+/)
    response[:user]          = elems[2].strip
    response[:host]          = elems[4].strip
    response[:host_ip]       = elems[5].strip[1...-1]

    record = records.shift
    elems = record.split(" ")
    response[:query_time]    = elems[2].to_f
    response[:lock_time]     = elems[4].to_f
    response[:rows_sent]     = elems[6].to_i
    response[:rows_examined] = elems[8].to_i

    response[:sql] = records.shift

    response
  end
end
