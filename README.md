## demo

![Alt text](/DeformationButton.gif)
![Alt text](/DeformationButton2.gif)

---------------------------------------
## code
	let deformationBtn = DeformationButton(frame: CGRectMake(100, 100, 140, 36), color: getColor("e13536"))
	self.view.addSubview(deformationBtn)

	deformationBtn.forDisplayButton.setTitle("微博注册", forState: UIControlState.Normal)
	deformationBtn.forDisplayButton.titleLabel?.font = UIFont.systemFontOfSize(15);
	deformationBtn.forDisplayButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
	deformationBtn.forDisplayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
	deformationBtn.forDisplayButton.setImage(UIImage(named:"微博logo.png"), forState: UIControlState.Normal)

	deformationBtn.addTarget(self, action: "btnEvent", forControlEvents: UIControlEvents.TouchUpInside)

---------------------------------------
### Thanks for [MMMaterialDesignSpinner]
[MMMaterialDesignSpinner]: https://github.com/misterwell/MMMaterialDesignSpinner