POLICY "VendorReviewer_US" {
	ASSIGN ROLE "VendorReviewer" WHERE country = 'US';
}

POLICY "VendorReviewer_CA" {
	ASSIGN ROLE "VendorReviewer" WHERE country = 'CA';
}
