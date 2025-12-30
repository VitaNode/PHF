# T9: Seeds Data Documentation

**Task ID**: T9
**Module**: Data Source / Seeder
**Description**: Describes the initial data populated into the database upon first creation.

## 1. Default User Profile
To support immediate usage without a complex registration flow (Local-First), a default profile is created.

- **Table**: `persons`
- **ID**: `def_me` (Static UUID-like string for reference)
- **Nickname**: `本人` (Default, editable later)
- **Is Default**: `1` (True)

## 2. System Tags (Teal Palette)
Pre-defined categories for medical documents, styled with the application's core Teal theme.

| ID | Name | Color (Hex) | Description |
| :--- | :--- | :--- | :--- |
| `sys_tag_1` | 检验 | `#009688` (Teal 500) | Lab results, blood tests, etc. |
| `sys_tag_2` | 检查 | `#26A69A` (Teal 400) | CT, MRI, Ultrasound, etc. |
| `sys_tag_3` | 病历 | `#00796B` (Teal 700) | Medical records, diagnosis. |
| `sys_tag_4` | 处方 | `#4DB6AC` (Teal 300) | Prescriptions, medication lists. |

**Note**:
- `is_custom` is set to `0` for these tags.
- Colors are chosen to be distinct yet monochromatic within the Teal spectrum.
