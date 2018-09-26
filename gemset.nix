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
      sha256 = "0bn6vyp2fznw82aa86k9z3805h1lhlwpcmmhi13m9sdnda60l8dl";
      type = "gem";
    };
    version = "1.104.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07c3ff83i5v2bxsvlzbs45kv3v8hjsmw6lzj75sxz2d5i2ylwmkb";
      type = "gem";
    };
    version = "3.27.1";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15dbclp8vfk2qn31s9dfzaamgg1ab068yff4wl8rbpc07x4dvm0n";
      type = "gem";
    };
    version = "1.9.0";
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
      sha256 = "0xqj21j3vfq4ldia6i2akhn2qd84m0iqcnsl49kfpq3xk6x0dzgn";
      type = "gem";
    };
    version = "0.9.0";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0087z9kbnlqhci7fxh9f6il63hj1k02icq2rs0c6cppmqchr753m";
      type = "gem";
    };
    version = "3.1";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04my3746hwa4yvbx1ranhfaqkgf6vavi1kyijjnw8w3dy37vqhkm";
      type = "gem";
    };
    version = "3.2016.0521";
  };
  mini_mime = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lwhlvjqaqfm6k3ms4v29sby9y7m518ylsqz2j74i740715yl5c8";
      type = "gem";
    };
    version = "1.0.0";
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
      sha256 = "05fm3xh462glvs0rwnfmc1spmgl4ljg2giifynbmwwqvl42zaaiq";
      type = "gem";
    };
    version = "1.8.2";
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
      sha256 = "1af7aa1c2npi8dkshgm3f8qyacabm94ckrdz7b8vd3f8zzswqzp9";
      type = "gem";
    };
    version = "2.5.1.0";
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
      sha256 = "0h0s1clasynlbk3782801c61yx24pdv959fpw53g5yl8gxqj34iz";
      type = "gem";
    };
    version = "1.1.1";
  };
  powerpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fnn3fli5wkzyjl4ryh0k90316shqjfnhydmc7f8lqpi0q21va43";
      type = "gem";
    };
    version = "0.1.1";
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
      sha256 = "1x5h1dh1i3gwc01jbg01rly2g6a1qwhynb1s8a30ic507z1nh09s";
      type = "gem";
    };
    version = "3.0.2";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "158hbn7rlc3czp2vivvam44dv6vmzz16qrh5dbzhfxbfsgiyrqw1";
      type = "gem";
    };
    version = "2.0.5";
  };
  rack-test = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l799s5qr2qrshvrggq5ch3v235y491zfww07b39w4pj4vpa65l1";
      type = "gem";
    };
    version = "1.0.0";
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
      sha256 = "1igh1xivf5h5g3y5m9b4i4j2mhz2r43kngh4ww3q1r80ch21nbfk";
      type = "gem";
    };
    version = "1.9.0";
  };
  rubyzip = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06js4gznzgh8ac2ldvmjcmg9v1vg9llm357yckkpylaj6z456zqz";
      type = "gem";
    };
    version = "1.2.1";
  };
  sass = {
    dependencies = ["sass-listen"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19wyzp9qsg8hdkkxlsv713w0qmy66qrdp0shj42587ssx4qhrlag";
      type = "gem";
    };
    version = "3.5.6";
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
      sha256 = "0hl7cch6qwhdp5x6kw91rci7yva7gq9vsqd5gxdqkw3h55d2jn60";
      type = "gem";
    };
    version = "0.57.0";
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
      sha256 = "1y61ijvv04bwga802s8py5xd7fcxci6478wgr9wkd35p45x20jzi";
      type = "gem";
    };
    version = "3.1.0";
  };
}