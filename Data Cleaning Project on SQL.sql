--- Standardize Data Format

Select*
From PortfolioProject.dbo.NashvilleHousing

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing 
SET SaleDate = Convert(Date, SaleDate)

Alter Table  PortfolioProject.dbo.NashvilleHousing 
Add SaleDateConverted Date; 

Update PortfolioProject.dbo.NashvilleHousing 
SET SaleDate = Convert(Date, SaleDate)


--Populate Property Address Data

Select*
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
order by ParcelID

Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress) 
From PortfolioProject.dbo.NashvilleHousing A
JOIN PortfolioProject.dbo.NashvilleHousing B
on A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
where A.PropertyAddress is NULL

Update A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress) 
From PortfolioProject.dbo.NashvilleHousing A
JOIN PortfolioProject.dbo.NashvilleHousing B
on A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID]
where A.PropertyAddress is NULL

-- Breaking out Address Into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
--order by ParcelID

Select 
Substring(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,Len(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

Alter Table  PortfolioProject.dbo.NashvilleHousing 
Add PropertySplitAddress Nvarchar(255); 

Update PortfolioProject.dbo.NashvilleHousing 
SET PropertySplitAddress=Substring(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)

Alter Table  PortfolioProject.dbo.NashvilleHousing 
Add PropertySplitCity Nvarchar(255); 

Update PortfolioProject.dbo.NashvilleHousing 
SET PropertySplitCity = Substring(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)

Select*
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','_'),3)
,PARSENAME(REPLACE(OwnerAddress,',','_'),2)
,PARSENAME(REPLACE(OwnerAddress,',','_'),1)
From PortfolioProject.dbo.NashvilleHousing



Alter Table  PortfolioProject.dbo.NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255); 

Update PortfolioProject.dbo.NashvilleHousing 
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','_'),3)

Alter Table  PortfolioProject.dbo.NashvilleHousing 
Add OwnderSplitCity Nvarchar(255); 

Update PortfolioProject.dbo.NashvilleHousing 
SET OwnderSplitCity=PARSENAME(REPLACE(OwnerAddress,',','_'),2)

Alter Table  PortfolioProject.dbo.NashvilleHousing 
Add OwnderSplitState Nvarchar(255); 

Update PortfolioProject.dbo.NashvilleHousing 
SET OwnderSplitState=PARSENAME(REPLACE(OwnerAddress,',','_'),1)

Select*
From PortfolioProject.dbo.NashvilleHousing

-- Change Y and N to Yes and No in 'Sold as Vacant' field 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant
order by 2

Select SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 
From PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
)

--DELETE
--From RowNumCTE
--Where row_num > 1


Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


---- Delete Unused Columns

Select*
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate
