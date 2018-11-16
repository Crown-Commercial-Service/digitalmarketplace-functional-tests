{
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
  };
  ast = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "184ssy3w93nkajlz2c70ifm79jp3j737294kbc5fjw69v1w0n9x7";
      type = "gem";
    };
    version = "2.4.0";
  };
  aws-eventstream = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gdiwkg24jpx5f3bkw6vchgliicn6v9bpm09j0dldaxsca66q0wy";
      type = "gem";
    };
    version = "1.0.1";
  };
  aws-partitions = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h4vpaslfgrmnr5xwaawb4283008h8p5nwlp41wgz7la467638g6";
      type = "gem";
    };
    version = "1.107.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01j110fpc6q9vvk3nhzvpji4kg89wa7z634s5vcy3c56035syjrf";
      type = "gem";
    };
    version = "3.36.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g13jv1s8hj1yv6qxa2rm0k3n5jzmamn3zk3c73276s3gixpp986";
      type = "gem";
    };
    version = "1.11.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16x5dg1ld4xvyds9ibr9hqf98qvq2pq6z8wcczzxqrfs9g0cwiij";
      type = "gem";
    };
    version = "1.20.0";
  };
  aws-sigv4 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hzndv113i6bgy2n72i5l3mwn8vjnb6hhjxfkpn9mm2p5ra77yk7";
      type = "gem";
    };
    version = "1.0.3";
  };
  builder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  capybara = {
    dependencies = ["addressable" "mini_mime" "nokogiri" "rack" "rack-test" "xpath"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yv77rnsjlvs8qpfn9n5vf1h6b9agxwhxw09gssbiw9zn9j20jh8";
      type = "gem";
    };
    version = "2.18.0";
  };
  capybara-screenshot = {
    dependencies = ["capybara" "launchy"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xy79lf3rwn3602r4hqm9s8a03bhlf6hzwdi6345dzrkmhwwj2ij";
      type = "gem";
    };
    version = "1.0.14";
  };
  childprocess = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a61922kmvcxyj5l70fycapr87gz1dzzlkfpq85rfqk5vdh3d28p";
      type = "gem";
    };
    version = "0.9.0";
  };
  cliver = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "096f4rj7virwvqxhkavy0v55rax10r4jqf8cymbvn4n631948xc7";
      type = "gem";
    };
    version = "0.3.2";
  };
  coderay = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vav4bhcc2x3jmi3izb11l4d9f3xv8hp2fszb7iqmpsccv1pz4y";
      type = "gem";
    };
    version = "1.1.2";
  };
  cucumber = {
    dependencies = ["builder" "cucumber-core" "cucumber-wire" "diff-lcs" "gherkin" "multi_json" "multi_test"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k4j31a93r0zhvyq2mm2k8irppbvkzbsg44r3mf023959v18fzih";
      type = "gem";
    };
    version = "2.4.0";
  };
  cucumber-core = {
    dependencies = ["gherkin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qj2fsqvp94nggnikbnrfvnmzr1pl6ifmdsxj69kdw1kkab30jjr";
      type = "gem";
    };
    version = "1.5.0";
  };
  cucumber-wire = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09ymvqb0sbw2if1nxg8rcj33sf0va88ancq5nmp8g01dfwzwma2f";
      type = "gem";
    };
    version = "0.0.1";
  };
  diff-lcs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
  };
  domain_name = {
    dependencies = ["unf"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0abdlwb64ns7ssmiqhdwgl27ly40x2l27l8hs8hn0z4kb3zd2x3v";
      type = "gem";
    };
    version = "0.5.20180417";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jpm2dis1j7zvvy3lg7axz9jml316zrn7s0j59vyq3qr127z0m7q";
      type = "gem";
    };
    version = "1.9.25";
  };
  gherkin = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d18r8mf2qyd9jbq9xxvca8adyysdzvwdy8v9c2s5hrd6p02kg79";
      type = "gem";
    };
    version = "4.1.3";
  };
  govuk-lint = {
    dependencies = ["rubocop" "rubocop-rspec" "scss_lint"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mf37hw4ny7lbkf6mwh81wgcnnzwrnm8pyfr2wjl2xj120q7spyz";
      type = "gem";
    };
    version = "3.7.0";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
      type = "gem";
    };
    version = "1.0.3";
  };
  jmespath = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d4wac0dcd1jf6kc57891glih9w57552zgqswgy74d1xhgnk0ngf";
      type = "gem";
    };
    version = "1.4.0";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lhinj9vj7mw59jqid0bjn2hlfcnq02bnvsx9iv81nl2han603s0";
      type = "gem";
    };
    version = "2.0.2";
  };
  jwt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "124zz1142bi2if7hl5pcrcamwchv4icyr5kaal9m2q6wqbdl6aw4";
      type = "gem";
    };
    version = "1.5.6";
  };
  launchy = {
    dependencies = ["addressable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190lfbiy1vwxhbgn4nl4dcbzxvm049jwc158r2x7kq3g5khjrxa2";
      type = "gem";
    };
    version = "2.4.3";
  };
  method_source = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jk3vvgjh9qhf4bkal76p1g9fi8aqnhgr33wcddwkny0nb73ms91";
      type = "gem";
    };
    version = "0.9.1";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fjxy1jm52ixpnv3vg9ld9pr9f35gy0jp66i1njhqjvmnvq0iwwk";
      type = "gem";
    };
    version = "3.2.2";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07wvp0aw2gjm4njibb70as6rh5hi1zzri5vky1q6jx95h8l56idc";
      type = "gem";
    };
    version = "3.2018.0812";
  };
  mini_mime = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q4pshq387lzv9m39jv32vwb8wrq3wc4jwgl4jk209r4l33v09d3";
      type = "gem";
    };
    version = "1.0.1";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13d32jjadpjj6d2wdhkfpsmy68zjx90p49bgf8f7nkpz86r1fr11";
      type = "gem";
    };
    version = "2.3.0";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  multi_test = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sx356q81plr67hg16jfwz9hcqvnk03bd9n75pmdw8pfxjfy1yxd";
      type = "gem";
    };
    version = "0.1.2";
  };
  netrc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byyxrazkfm29ypcx5q4syrv126nvjnf7z6bqi01sqkv4llsi4qz";
      type = "gem";
    };
    version = "1.8.5";
  };
  notifications-ruby-client = {
    dependencies = ["jwt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z4pawvms2xqsn64x0ixs7q76bdnqsflwp2kn776z7m43ww14msi";
      type = "gem";
    };
    version = "2.2.0";
  };
  parallel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01hj8v1qnyl5ndrs33g8ld8ibk0rbcqdpkpznr04gkbxd11pqn67";
      type = "gem";
    };
    version = "1.12.1";
  };
  parallel_tests = {
    dependencies = ["parallel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fg7l97wwb3d92p89vmky83ngwfcf8408fdcv2nazghcglwph84x";
      type = "gem";
    };
    version = "2.15.0";
  };
  parser = {
    dependencies = ["ast"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zjk0w1kjj3xk8ymy1430aa4gg0k8ckphfj88br6il4pm83f0n1f";
      type = "gem";
    };
    version = "2.5.3.0";
  };
  phantomjs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y8pbbyq9dirxb7igkb2s5limz2895qmr41c09fjhx6k6fxcz4mk";
      type = "gem";
    };
    version = "2.1.1.0";
  };
  poltergeist = {
    dependencies = ["capybara" "cliver" "websocket-driver"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "098zgqhhphazxsikrj5mpsrij0l726wig26nn04bmm4r7n0zi5yl";
      type = "gem";
    };
    version = "1.11.0";
  };
  power_assert = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x5qcfm8ka7anaady81qahhn9y4f6j86kvyqma7d2hnri4ahflvh";
      type = "gem";
    };
    version = "1.1.3";
  };
  powerpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r51d67wd467rpdfl6x43y84vwm8f5ql9l9m85ak1s2sp3nc5hyv";
      type = "gem";
    };
    version = "0.1.2";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mh312k3y94sj0pi160wpia0ps8f4kmzvm505i6bvwynfdh7v30g";
      type = "gem";
    };
    version = "0.11.3";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08q64b5br692dd3v0a9wq9q5dvycc6kmiqmjbdxkxbfizggsvx6l";
      type = "gem";
    };
    version = "3.0.3";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pcgv8dv4vkaczzlix8q3j68capwhk420cddzijwqgi2qb4lm1zm";
      type = "gem";
    };
    version = "2.0.6";
  };
  rack-test = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rh8h376mx71ci5yklnpqqn118z3bl67nnv5k801qaqn1zs62h8m";
      type = "gem";
    };
    version = "1.1.0";
  };
  rainbow = {
    dependencies = ["rake"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08w2ghc5nv0kcq5b257h7dwjzjz1pqcavajfdx2xjyxqsvh2y34w";
      type = "gem";
    };
    version = "2.2.2";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cnjmbcyhm4hacpjn337mg1pnaw6hj09f74clwgh6znx8wam9xla";
      type = "gem";
    };
    version = "11.3.0";
  };
  rb-fsevent = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lm1k7wpz69jx7jrc92w3ggczkjyjbfziq5mg62vjnxmzs383xx8";
      type = "gem";
    };
    version = "0.10.3";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yfsgw5n7pkpyky6a9wkf1g9jafxb0ja7gz0qw0y14fd2jnzfh71";
      type = "gem";
    };
    version = "0.9.10";
  };
  report_builder = {
    dependencies = ["builder" "json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bwbly3i50qdh272gvy0qff0741cykx44kapm0m2cy55wrdn3hpm";
      type = "gem";
    };
    version = "0.1.4";
  };
  rest-client = {
    dependencies = ["http-cookie" "mime-types" "netrc"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v2jp2ilpb2rm97yknxcnay9lfagcm4k82pfsmmcm9v290xm1ib7";
      type = "gem";
    };
    version = "2.0.0";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16g3mmih999f0b6vcz2c3qsc7ks5zy4lj1rzjh8hf6wk531nvc6s";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nacs062qbr98fx6czf1vwppn1js956nv2c8vfwj6i65axdfs46i";
      type = "gem";
    };
    version = "3.5.4";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bbqfrb1x8gmwf8x2xhhwvvlhwbbafq4isbvlibxi6jk602f09gs";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nl3ksivh9wwrjjd47z5dggrwx40v6gpb3a0gzbp1gs06a5dmk24";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-support = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10vf3k3d472y573mag2kzfsfrf6rv355s13kadnpryk8d36yq5r0";
      type = "gem";
    };
    version = "3.5.0";
  };
  rubocop = {
    dependencies = ["parallel" "parser" "powerpack" "rainbow" "ruby-progressbar" "unicode-display_width"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cy2plq67b47ql06ypx3svbnnjmr2q616scwyhfd6330cg0aacf1";
      type = "gem";
    };
    version = "0.51.0";
  };
  rubocop-rspec = {
    dependencies = ["rubocop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rszh3yfzpwyy8d7729qa3gpswsq3zj5yw44arksm4dyrd07r16i";
      type = "gem";
    };
    version = "1.19.0";
  };
  ruby-prof = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02z4lh1iv1d8751a1l6r4hfc9mp61gf80g4qc4l6gbync3j3hf2c";
      type = "gem";
    };
    version = "0.17.0";
  };
  ruby-progressbar = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cv2ym3rl09svw8940ny67bav7b2db4ms39i4raaqzkf59jmhglk";
      type = "gem";
    };
    version = "1.10.0";
  };
  rubyzip = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n1lb2sdwh9h27y244hxzg1lrxxg2m53pk1vq7p33bna003qkyrj";
      type = "gem";
    };
    version = "1.2.2";
  };
  sass = {
    dependencies = ["sass-listen"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18c6prbw9wl8bqhb2435pd9s0lzarl3g7xf8pmyla28zblvwxmyh";
      type = "gem";
    };
    version = "3.6.0";
  };
  sass-listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";
      type = "gem";
    };
    version = "4.0.0";
  };
  scss_lint = {
    dependencies = ["rake" "sass"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dv4ff1lqbgqdx99nwg059c983dhw67kvvjd21f6vf62cjx09lpn";
      type = "gem";
    };
    version = "0.57.1";
  };
  selenium-webdriver = {
    dependencies = ["childprocess" "rubyzip" "websocket"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "063fbypf0sq3jijjz4zvjjy5pahpyvx0xjwj11cpbzq1ksd6jf55";
      type = "gem";
    };
    version = "3.0.0";
  };
  test-unit = {
    dependencies = ["power_assert"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c6grgvwapy6vxkbpmflf9f7xlpxi4ck99mw4jlimpryp8lrnnah";
      type = "gem";
    };
    version = "3.2.1";
  };
  unf = {
    dependencies = ["unf_ext"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06p1i6qhy34bpb8q8ms88y6f2kz86azwm098yvcc0nyqk9y729j1";
      type = "gem";
    };
    version = "0.0.7.5";
  };
  unicode-display_width = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0040bsdpcmvp8w31lqi2s9s4p4h031zv52401qidmh25cgyh4a57";
      type = "gem";
    };
    version = "1.4.0";
  };
  websocket = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f11rcn4qgffb1rq4kjfwi7di79w8840x9l74pkyif5arp0mb08x";
      type = "gem";
    };
    version = "1.2.8";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1551k3fs3kkb3ghqfj3n5lps0ikb9pyrdnzmvgfdxy8574n4g1dn";
      type = "gem";
    };
    version = "0.7.0";
  };
  websocket-extensions = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "034sdr7fd34yag5l6y156rkbhiqgmy395m231dwhlpcswhs6d270";
      type = "gem";
    };
    version = "0.1.3";
  };
  xpath = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";
      type = "gem";
    };
    version = "3.2.0";
  };
}