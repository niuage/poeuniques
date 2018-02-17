require 'rails_helper'

describe Import::Unique do
  let(:html) {
    %Q{
      <td>
      <span class="c-item-hoverbox__display" style="top: 4011.31px; left: 117.5px; display: none;">
        <span class="item-box -unique">
          <span class="header -double">
            Windripper<br>Imperial Bow
          </span>
          <span class="item-stats">
            <span class="group">
              <em class="tc -default">Bows</em>
              <br>
              <em class="tc -default">Quality: <em class="tc -mod">+20%</em></em>
              <br>
              <em class="tc -default">Physical Damage: <em class="tc -value"><em class="tc -mod">22.8</em>–<em class="tc -mod">(264.6 to 324.5)</em></em></em>
              <em class="tc -default">Chaos Damage: <em class="tc -value"><em class="tc -chaos">(50 to 80)–(130 to 180)</em></em></em>
              <br>
              Elemental Damage:
              <em class="tc -cold">(32 to 40)–(48 to 60)</em>
              <em class="tc -lightning">1–(80 to 100)</em>
              <br>
              <em class="tc -default">Critical Strike Chance: <em class="tc -value"><em class="tc -mod">(8.00% to 9.00%)</em></em></em>
              <br>
              <em class="tc -default">Attacks per Second: <em class="tc -value"><em class="tc -mod">(1.59 to 1.67)</em></em></em>
              <br>
              <em class="tc -default">Weapon Range: <em class="tc -value"><em class="tc -value">120</em></em></em>
            </span>
            <span class="group">
              <em class="tc -default">
                Requires Level <em class="tc -value"><em class="tc -value">66</em></em>,
                <em class="tc -value"><em class="tc -value">212</em></em>
                Dex
              </em>
            </span>
            <span class="group -textwrap tc -mod">(20-24)% increased <a href="/Elemental_Damage" class="mw-redirect" title="Elemental Damage">Elemental Damage</a> with <a href="/Attack" title="Attack">Attack</a> <a href="/Skill" class="mw-redirect" title="Skill">Skills</a></span><span class="group -textwrap tc -mod">Adds (32-40) to (48-60) <a href="/Cold_Damage" class="mw-redirect" title="Cold Damage">Cold Damage</a><br>Adds 1 to (80-100) <a href="/Lightning_Damage" class="mw-redirect" title="Lightning Damage">Lightning Damage</a><br>(10-15)% increased <a href="/Attack_Speed" class="mw-redirect" title="Attack Speed">Attack Speed</a><br>(60-80)% increased <a href="/Critical_Strike_Chance" class="mw-redirect" title="Critical Strike Chance">Critical Strike Chance</a><br>15% increased Quantity of Items Dropped by Slain <a href="/Freeze" title="Freeze">Frozen</a> Enemies<br>30% increased Rarity of Items Dropped by Slain <a href="/Shock" title="Shock">Shocked</a> Enemies</span><span class="group -textwrap tc -flavour">It hunts; as silent as falling snow, as deadly as the tempest.</span></span></span><img alt="" src="https://d1u5p3l4wpay3k.cloudfront.net/pathofexile_gamepedia/e/ed/Windripper_inventory_icon.png?version=131552349f70b035c82bad9375767e87" width="156" height="312"></span>
      </td>
    }
  }

  let(:tds) {
    Nokogiri::HTML(html).css("td")
  }

  let(:type) { "bow" }

  subject { described_class.for(type) }

  before do
    subject.parse(tds)
  end

  it "should parse the name and base_name" do
    item = subject.item

    expect(item).to be_persisted

    expect(item.name).to eq "Windripper"
    expect(item.base_name).to eq "Imperial Bow"
    expect(item.type).to eq type

    expect(item.quality).to eq 20
    expect(item.required_str).to eq 0
    expect(item.required_dex).to eq 212
    expect(item.required_int).to eq 0
    expect(item.level_requirement).to eq 66

    expect(item.physical_damage).to eq "22.8–(264.6 to 324.5)"
    expect(item.cold_damage).to eq "(32 to 40)–(48 to 60)"
    expect(item.lightning_damage).to eq "1–(80 to 100)"
    expect(item.chaos_damage).to eq "(50 to 80)–(130 to 180)"

    expect(item.attacks_per_second).to eq "(1.59 to 1.67)"
    expect(item.critical_strike_chance).to eq "(8.00% to 9.00%)"

    expect(item.weapon_range).to eq 120

    expect(item.item_mods.implicit.count).to eq 1
    expect(item.item_mods.regular.count).to eq 6

    expect(item.image_url).to eq "https://d1u5p3l4wpay3k.cloudfront.net/pathofexile_gamepedia/e/ed/Windripper_inventory_icon.png"

    expect(item.flavor_text).to eq "It hunts; as silent as falling snow, as deadly as the tempest."
  end

end
