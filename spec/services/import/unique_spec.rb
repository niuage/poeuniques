require 'rails_helper'

describe Import::Unique do
  let(:html) {
    %Q{
      <td>
      <span class="c-item-hoverbox__display" style="top: 256.734px; left: 110.344px; display: none;">
        <span class="item-box -unique">
          <span class="header -double">
            Bramblejack
            <br>
            Plate Vest
          </span>
          <span class="item-stats">
            <span class="group">
              <em class="tc -default">Quality: <em class="tc -mod">+20%</em></em>
              <br>
              <em class="tc -default">Armour: <em class="tc -value"><em class="tc -mod">22</em></em></em>
              <br>
              <em class="tc -default">Energy Shield: <em class="tc -value"><em class="tc -mod">(198 to 247)</em></em></em>
              <br>
              <em class="tc -default">Evasion: <em class="tc -value"><em class="tc -mod">(426 to 465)</em></em></em>
            </span>
            <span class="group">
              <em class="tc -default">
                Requires Level
                <em class="tc -value"><em class="tc -value">62</em></em>,
                <em class="tc -value"><em class="tc -value">12</em></em>
                Str
              </em>
            </span>
            <span class="group -textwrap tc -mod">
              3% reduced Movement Speed (Hidden)
            </span>
            <span class="group -textwrap tc -mod">
              Adds 2 to 4
              <a href="/Physical_Damage" title="Physical Damage">
                Physical Damage
              </a>
              to
              <a href="/Attack" title="Attack">Attacks</a>
              <br>
              +(12-20) to maximum <a href="/Life" title="Life">Life</a>
              <br>
              -2 <a href="/Physical_Damage" class="mw-redirect" title="Physical Damage">Physical Damage</a>
              taken from
              <a href="/Attack" title="Attack">Attacks</a>
              <br>
              40% of Melee <a href="/Physical_Damage" class="mw-redirect" title="Physical Damage">Physical Damage</a> taken reflected to Attacker
            </span>
            <span class="group -textwrap tc -flavour">
              It is safer to be feared than to be loved.
              <br>
              It is safer to be feared than to be loved.
            </span>
          </span>
        </span>
        <img alt="" src="https://d1u5p3l4wpay3k.cloudfront.net/pathofexile_gamepedia/2/28/Bramblejack_inventory_icon.png?version=063e2a03587e1da6d1c462a9debd4d10" width="156" height="234">
      </span>
      </td>
    }
  }

  let(:tds) {
    Nokogiri::HTML(html).css("td")
  }

  let(:type) { "body_armour" }

  subject { described_class.for(type) }

  before do
    subject.parse(tds)
  end

  it "should parse the name and base_name" do
    item = subject.item

    expect(item).to be_persisted

    expect(item.name).to eq "Bramblejack"
    expect(item.base_name).to eq "Plate Vest"
    expect(item.type).to eq type

    expect(item.quality).to eq 20
    expect(item.required_str).to eq 12
    expect(item.required_dex).to eq 0
    expect(item.required_int).to eq 0
    expect(item.level_requirement).to eq 62

    expect(item.min_armour).to eq 22
    expect(item.max_armour).to eq 22

    expect(item.min_energy_shield).to eq 198
    expect(item.max_energy_shield).to eq 247

    expect(item.min_evasion).to eq 426
    expect(item.max_evasion).to eq 465

    expect(item.item_mods.implicit.count).to eq 1
    expect(item.item_mods.regular.count).to eq 4

    expect(item.image_url).to eq "https://d1u5p3l4wpay3k.cloudfront.net/pathofexile_gamepedia/2/28/Bramblejack_inventory_icon.png"

    expect(item.flavor_text).to eq "It is safer to be feared than to be loved.|||It is safer to be feared than to be loved."
  end

end
